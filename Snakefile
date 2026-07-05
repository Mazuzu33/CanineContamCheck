import pandas as pd

configfile: "config/config.yaml"

# Read in sample csv and extract the sample names and paths
sample_df = pd.read_csv(config["samples_csv"])
sample_names = list(sample_df["samplename"])
sample_dict_paths = dict(zip(sample_df["samplename"], sample_df["samplepath"]))
sample_dict_breed = dict(zip(sample_df["samplename"], sample_df["breed"]))

# Input function to return the corresponding sample path given a sample name
def get_sample_path(wildcards):
    return sample_dict_paths[wildcards.sample]

# Generate sample csv files
rule all:
    input:
        config["contam_csv"],
        config["pc_csv"]

rule verifybamid:
    input:
        bam=get_sample_path
    output:
        selfsm="results/{sample}/{sample}.selfSM",
        ancestry="results/{sample}/{sample}.Ancestry"
    conda:
        "envs/verifybamid.yaml"
    shell:
        """
        verifybamid2 --SVDPrefix {config[resource_files]} \
        --Reference {config[reference_genome]} \
        --NumPC 3 \
        --BamFile {input.bam} \
        --IncludeChr "chr1, chr2, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chr10, chr11, chr12, chr13, chr14, chr15, chr16, chr17, chr18, chr19, chr20, chr21, chr22, chr23, chr24, chr25, chr26, chr27, chr28, chr29, chr30, chr31, chr32, chr33, chr34, chr35, chr36, chr37, chr38, chr39" \
        --Output results/{wildcards.sample}/{wildcards.sample}
        """

# Ensure coordinate sorted bam is available
rule coordinatesortbam:
    input:
        bam=get_sample_path
    output:
        bam_cs="tmp/{sample}/{sample}.cs.bam",
        bam_cs_ind="tmp/{sample}/{sample}.cs.bam.bai"
    conda:
        "envs/samtools.yaml"
    shell:
        """
        samtools sort {input.bam} -o {output.bam_cs} --reference {config[reference_genome]}
        samtools index {output.bam_cs}
        """
    
rule qualimap:
    input:
        bam="tmp/{sample}/{sample}.cs.bam"
    resources:
        mem_mb=4096,
    output:
        directory("results/{sample}/{sample}.qualimap")
    wrapper:
        "v7.6.0/bio/qualimap/bamqc"

rule bamcsv:
    input:
        qualimap="results/{sample}/{sample}.qualimap",
        selfsm="results/{sample}/{sample}.selfSM"
    output:
        bam_csv="results/{sample}/{sample}.csv"
    run:
        genome_results=f"{input.qualimap}/genome_results.txt"
        warnings = []
        # Check the percentage of reads aligned and the mean coverage
        with open(genome_results, "r") as qualimap:
            for line in qualimap:
                if "number of mapped reads" in line:  
                    start = line.find("(") + 1
                    end = line.find("%")
                    percent_aligned = float(line[start:end])
                    if percent_aligned < config["percent_aligned"]:
                        warnings.append("LOW PERCENT ALIGNED")
                elif "mean coverageData" in line:
                    start = line.find("=") + 2
                    end = line.find("X")
                    mean_coverage = float(line[start:end])
                    if mean_coverage < config["mean_coverage"]:
                        warnings.append("LOW MEAN COVERAGE")
        # Check the verifybamid freemix score
        with open(input.selfsm, "r") as selfsm:
            lines = selfsm.readlines()
            selfsm_values = lines[1].split('\t')
            freemix = float(selfsm_values[6])
            if freemix >= config["freemix"]:
                warnings.append("FREEMIX CONTAMINATION")
        # Append the warnings together to form a label
        label = "/".join(warnings)
        # Create a dataframe containing the bam data
        bam_data = {
            "Sample": [wildcards.sample],
            "Warnings": [label]
        }
        bam_df = pd.DataFrame(bam_data)
        # Write the dataframe to a csv file
        bam_df.to_csv(output.bam_csv, index=False)

# Aggregate all the indivdual csv's to one
rule aggcsv:
    input:
        expand("results/{sample}/{sample}.csv", sample=sample_names)
    output:
        contam_csv=config["contam_csv"]
    run:
        # Read in every individual csv
        sample_dfs = [pd.read_csv(file) for file in input]
        # Stack the csv's together to create a new csv
        concat_df = pd.concat(sample_dfs, ignore_index=True)
        concat_df.to_csv(output.contam_csv, index=False)

rule aggcoords:
    input: 
        coords=expand("results/{sample}/{sample}.Ancestry", sample=sample_names),
    output:
        pc_csv=config["pc_csv"]
    run:
        coords_data = []
        # For each ancestry file, create a dictionary containing the name, breed, and pc coordinate data
        for file, name in zip(input.coords, sample_names):
            coord_df = pd.read_csv(file, sep='\t')
            coords_data.append({
                "Sample Name": name,
                "Breed": sample_dict_breed[name],
                "PC1": coord_df.loc[0, "IntendedSample"],
                "PC2": coord_df.loc[1, "IntendedSample"],
                "PC3": coord_df.loc[2, "IntendedSample"]
            })
        # Create a new dataframe from all of the dictionaries and write it to a csv file
        coords_df = pd.DataFrame(coords_data)
        coords_df.to_csv(output.pc_csv, index=False)
        

            







