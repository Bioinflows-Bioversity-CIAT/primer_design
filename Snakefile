#rule all:
#	input:
#		blastn_outs = 


rule create_blast_db:
	input:
		ref_fasta = "fastas/{ref_name}.fa"
	output:
		blast_db = multitext("blast_dbs/{ref_name}/{ref_name}",
		'.ndb', '.nhr', '.nin',
		'.njs', '.not', '.nsq', 
		'.ntf', '.nto')
	shell :
		"""
		makeblastdb -in {input.ref_fasta} \
		 -out blast_dbs/{wildcards.ref_name}/{wildcards.ref_name} \
		 -dbtype nucl
		"""

rule blastn_job:
	input:
		query = 'queries/{query_id}.fa',
		blast_db = multitext("blast_dbs/{ref_name}/{ref_name}",
		'.ndb', '.nhr', '.nin',
		'.njs', '.not', '.nsq', 
		'.ntf', '.nto')
	output:
		blastn_out = 'blast/{query_id}/{ref_name}_{query_id}.out'
	params:
		out_fmt = 6
	threads:
		10
	shell:
		"""
		blastn -query {input.query} \
			-db blast_dbs/{wildcards.ref_name}/{wildcards.ref_name} \
			-out {output.blastn_out} \
			-task blastn-short \
			-outfmt {params.out_fmt} \
			-num_threads {threads}
		"""
