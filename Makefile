data-flow.svg: data-flow.mmd
	mmdc -i $< -o $@

data-flow.mmd: data-flow.pg
	pgraph $< $@
