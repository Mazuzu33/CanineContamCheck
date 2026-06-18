configfile: "config/config.yaml"

wildcard_constraints:
    filetype="(bam|cram)"

rule all:
    input:
        "results/{sample}/{sample}.{filetype}.selfSM",
        "results/{sample}/{sample}.{filetype}.ancestry"

rule verifybamid:
    input:
        bam="{sample}.{filetype}"
    output:
        selfsm="results/{sample}/{sample}.{filetype}.selfSM",
        ancestry="results/{sample}/{sample}.{filetype}.ancestry"
    conda:
        "envs/verifybamid.yaml"
    shell:
        """
        verifybamid2 --SVDPrefix {config[resource_files]}
        --Reference {config[reference_panel]}
        --NumPC 3
        --BamFile {wildcards.sample}.{wildcards.filetype}
        --Output results/{wildcards.sample}.{wildcards.filetype}
        """

        
