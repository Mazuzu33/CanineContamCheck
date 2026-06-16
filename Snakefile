configfile: "config/config.yaml"

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
        verifybamid2 --SVDPrefix {config[resource_files]}
        --Reference {config[reference_panel]}
        --NumPC 3
        --BamFile {wildcards.sample}.bam
        --Output results/{wildcards.sample}
        """

