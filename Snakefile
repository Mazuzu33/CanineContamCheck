configfile: "config/config.yaml"

SAMPLES, SUFFIXES, FILETYPES = glob_wildcards("samples/{sample}.{suffix}.{filetype, bam|cram}")

rule all:
    input:
        expand("results/{sample}/{sample}.{suffix}.{filetype}.selfSM", zip, sample=SAMPLES, suffix=SUFFIXES, filetype=FILETYPES),
        expand("results/{sample}/{sample}.{suffix}.{filetype}.ancestry", zip, sample=SAMPLES, suffix=SUFFIXES, filetype=FILETYPES)

rule verifybamid:
    input:
        bam="samples/{sample}.{suffix}.{filetype}"
    output:
        selfsm="results/{sample}/{sample}.{suffix}.{filetype}.selfSM",
        ancestry="results/{sample}/{sample}.{suffix}.{filetype}.ancestry"
    conda:
        "envs/verifybamid.yaml"
    shell:
        """
        ls data/reference_genomes/UU_Cfam_GSD_1.0_ROSY/UU_Cfam_GSD_1.0_ROSY.fa.gz
        verifybamid2 --SVDPrefix {config[resource_files]} \
        --Reference {config[reference_genome]} \
        --NumPC 3 \
        --BamFile {input.bam} \
        --IncludeChr "chr1, chr2, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chr10, chr11, chr12, chr13, chr14, chr15, chr16, chr17, chr18, chr19, chr20, chr21, chr22, chr23, chr24, chr25, chr26, chr27, chr28, chr29, chr30, chr31, chr32, chr33, chr34, chr35, chr36, chr37, chr38, chr39" \
        --Output results/{wildcards.sample}/{wildcards.sample}.{wildcards.suffix}.{wildcards.filetype}
        """



        
