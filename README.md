# CanineContamCheck
CanineContamCheck is a tool used to check for signs of contamination or breed mismatches in canine genetic data. The tool consists of two pipelines. The first pipeline, BamCheck, takes in BAM/CRAM files and checks the samples' mean coverage, percentage of reads aligned, and freemix score. It also creates a principal component analysis (PCA) plot of these samples overlaid onto a large canine reference panel containing 4461 samples, allowing for visual inspection of breed mismatches. The second pipeline, GvcfCheck, takes in GVCF files and checks the samples' Ts/Tv ratio, indel amount, charr, and inconsistent_ab_het_rate.

## Dependencies
- Pixi

## Initial Setup
CanineContamCheck is designed to work only on Linux and macOS operating systems.

1. Install pixi following the installation guide (https://pixi.prefix.dev/latest/installation/)
2. Clone the github repo
3. Run setup.sh in your terminal. This will pull the reference genome from the Minnesota Supercomputing Institute's secondary storage.

## BamCheck
**Prepare input CSV file**
BamCheck expects an input CSV file with column headers samplename, breed, and samplepath. This information should be entered on a new row for each sample.
```
samplename,breed,samplepath
SampleA,dobp,/path/to/bam/or/cram
```
The breed should be a standardized abbreviation as specified by this document (https://docs.google.com/spreadsheets/d/1hOFzJQtt-7muhVQqF6XZjY-MHX9g5OzZaSThv7SWPqM/edit?gid=0#gid=0). Note that the path to the BAM or CRAM file can either be absolute or relative to the BamCheck directory.

**Setup configurations**
BamCheck can be configured differently based on the user's own preferences. To change default configurations, open `CanineContamCheck/BamCheck/config/config.yaml`. Paths to these settings can be provided as absolute or as relative to the BamCheck directory. 
- sample_csv: The path to the input CSV file. Defaults to `config/samples.csv `.
- contam_csv: The path to the output CSV file containing contaminated samples and their warnings. Defaults to `results/contam.csv`.
- pc_csv: The path to the output CSV file containing samples and their PC coordinates. Defaults to `results/pc.csv`.
- pc_plot: The path to the output directory where HTML files containg PC plots will be saved. Defaults to `results/pc_plots`.
- resource_files: The path to the resource files generated from VerifyBamID. VerifyBamID expects 4 files that contain this path with suffixes of .bed, .mu, .UD, and .V. Refer to (https://github.com/griffan/VerifyBamID) if you wish to generate your own. Note that the resource files must be generated using the same reference genome as specified here. Defaults to `data/verifybamid/resource_files/dog_wgs.n3973.UU_Cfam_GSD_1.0_ROSY.20251223.snps.phased.filter.prune.vcf.gz`.
- reference_genome: The path to the FASTA file containing the reference genome that samples were aligned to. Defaults to `data/reference_genomes/UU_Cfam_GSD_1.0_ROSY/UU_Cfam_GSD_1.0_ROSY.fa.gz`.
- percent_aligned: The minimum threshold for the percentage of reads that should align to the reference genome. Defaults to 90.
- mean_coverage: The minimum threshold for the mean coverage or depth of the genome. Defaults to 20.
- freemix: The maximum threshold for the freemix score. The freemix score is calculated by VerifyBamID and estimates intraspecies contamination. While the threshold is normally set to 0.05 for humans, this was found to be too strict for canines. Defaults to 0.10. 

**Interpreting results**
BamCheck's main output is the CSV file specified by contam_csv, which will list any samples that failed the thresholds listed in `CanineContamCheck/BamCheck/config/config.yaml`. It will also specify which thresholds each sample failed.
- LOW PERCENT ALIGNED: Sample failed the percent_aligned threshold.
- LOW MEAN COVERAGE: Sample failed the mean_coverage threshold.
- FREEMIX CONTAMINATION: Sample failed the freemix threshold.

BamCheck's secondary output are the PCA plots located in the directory specified by pc_csv. A PCA plot will be generated for each unique breed in the input CSV file, as long as the breed is also present in the reference panel. The output HTML file will be named pc_{breed-abbreviation}.html. By opening this file in a web browser, you can manually identify breed mismatches. Blue dots correspond to the breed in question, whereas gray dots correspond to all other breeds. A black outline around a blue dot specifies that it came from a sample in the input CSV file. If such a dot is far enough away from all other blue dots, than it can be tenatively concluded that the sample's breed is incorrect.





