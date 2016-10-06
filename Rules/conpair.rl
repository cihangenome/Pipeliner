rule conpair:
    input: normal=lambda wildcards: config['project']['pairs'][wildcards.x][0]+".recal.bam",
           tumor=lambda wildcards: config['project']['pairs'][wildcards.x][1]+".recal.bam"
    output: "{x}.conpair"
    params: tumorsample=lambda wildcards: config['project']['pairs'][wildcards.x][1],normalsample=lambda wildcards: config['project']['pairs'][wildcards.x][0],genome=config['references'][pfamily]['GENOME'],markers=config['references'][pfamily]['CONPAIRMARKERS'],rname="pl:conpair"
    shell: "module load conpair; run_gatk_pileup_for_sample.py -B {input.normal} -R {params.genome} -O {params.normalsample}.pileup; run_gatk_pileup_for_sample.py -B {input.tumor} -R {params.genome} -O {params.tumorsample}.pileup; estimate_tumor_normal_contamination.py -T {params.tumorsample}.pileup -N {params.normalsample}.pileup -O {output} -M {params.markers}"