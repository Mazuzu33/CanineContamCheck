# CanineContamCheck
CanineContamCheck is a tool used to check for signs of contamination or breed mismatches in canine genetic data. The tool consists of two pipelines. The first pipeline takes in BAM/CRAM files and checks the samples' mean coverage, percentage of reads aligned, and FREEMIX score as calculated by VerifyBamID. It also creates a PCA plot of these samples overlaid onto a large canine reference panel, allowing for visual inspection of breed mismatches. The second pipeline takes in GVCF files and checks the samples' Ts/Tv ratio, indel amount, and CHARR as well as INCONSISTENT_AB_HET_RATE as calculated by sceVCF.

## Dependencies
- Pixi

## Initial Setup
CanineContamCheck is designed to work only on Linux and macOS operating systems.

1. Install pixi following the installation guide (https://pixi.prefix.dev/latest/installation/)
2. Clone the github repo
3. Run setup.sh in your terminal. This will pull the reference genome from the Minnesota Supercomputing Institute's secondary storage.

