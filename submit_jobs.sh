#!/bin/bash -l
#SBATCH --time=24:00:00
#SBATCH --mem=50g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=wu001474@umn.edu
#SBATCH -p msismall
#SBATCH -o /projects/standard/fried255/shared/ForMazuki/logs/slurm-%j.out

cd /projects/standard/fried255/shared/ForMazuki/CanineContamCheck
module load miniforge
source activate ../snakemake_env_test
snakemake --sdm conda \
--executor slurm \
--default-resources slurm_account=$1 slurm_partition="msismall" \
--jobs 4