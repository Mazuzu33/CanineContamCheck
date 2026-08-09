#!/bin/bash -l
wget -P BamCheck/data/reference_genomes/UU_Cfam_GSD_1.0_ROSY https://s3.msi.umn.edu/caninecontamcheck/ref_gen/UU_Cfam_GSD_1.0_ROSY/UU_Cfam_GSD_1.0_ROSY.fa.gz
wget -P BamCheck/data/reference_genomes/UU_Cfam_GSD_1.0_ROSY https://s3.msi.umn.edu/caninecontamcheck/ref_gen/UU_Cfam_GSD_1.0_ROSY/UU_Cfam_GSD_1.0_ROSY.fa.gz.fai 
wget -P GvcfCheck/data/reference_genomes/UU_Cfam_GSD_1.0_ROSY https://s3.msi.umn.edu/caninecontamcheck/ref_gen/UU_Cfam_GSD_1.0_ROSY/UU_Cfam_GSD_1.0_ROSY.fa.gz
wget -P GvcfCheck/data/reference_genomes/UU_Cfam_GSD_1.0_ROSY https://s3.msi.umn.edu/caninecontamcheck/ref_gen/UU_Cfam_GSD_1.0_ROSY/UU_Cfam_GSD_1.0_ROSY.fa.gz.fai 

wget -P GvcfCheck/data/reference_panel/UU_Cfam_GSD_1.0_ROSY https://s3.msi.umn.edu/caninecontamcheck/ref_panel/UU_Cfam_GSD_1.0_ROSY/dog_wgs.n3973.UU_Cfam_GSD_1.0_ROSY.20251223.snps.phased.AF.vcf.gz
wget -P GvcfCheck/data/reference_panel/UU_Cfam_GSD_1.0_ROSY https://s3.msi.umn.edu/caninecontamcheck/ref_panel/UU_Cfam_GSD_1.0_ROSY/dog_wgs.n3973.UU_Cfam_GSD_1.0_ROSY.20251223.snps.phased.AF.vcf.gz.tbi