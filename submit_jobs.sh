#!/bin/bash -l
#SBATCH --time=96:00:00
#SBATCH --mem=50g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=wu001474@umn.edu
#SBATCH -p msismall
#SBATCH -o /projects/standard/fried255/shared/ForMazuki/logs/slurm-%j.out

cd /projects/standard/fried255/shared/ForMazuki/CanineContamCheck
pixi shell
snakemake --workflow-profile profiles/slurm/profile.yaml