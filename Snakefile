rule verifybamid:
    input:
        bam="{sample}.bam"
    output:
        selfsm="results/{sample}/{sample}.selfSM"
        ancestry="results/{sample}/{sample}.ancestry"
    conda:
        "envs/verifybamid.yaml"
    shell:
        r"""
        verifybamid2 --SVDPrefix data/verifybamid/resource_files/dog_wgs.n3973.UU_Cfam_GSD_1.0_ROSY.20251223.snps.phased.filter.prune.vcf.gz \
        --Reference data/reference_genomes/UU_Cfam_GSD_1.0_ROSY/UU_Cfam_GSD_1.0_ROSY.fa.gz \
        --NumPC 3 \
        --BamFile {wildcards.sample}.bam \
        --Output results/{wildcards.sample}
        """

