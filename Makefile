default: data-flow.svg crm-classes.svg crm-expand.txt

data-flow.svg: data-flow.mmd
	mmdc -i $< -o $@

data-flow.mmd: data-flow.pg
	pgraph --html $< $@

crm-classes.svg: crm-classes.mmd
	mmdc -i $< -o $@

crm-classes.mmd: crm-classes.pg
	pgraph --html $< $@

crm-expand.txt: crm-expand.tsv
	./expansion-list.pl < $< > $@

crm-expand.tsv: crm-classes.pg
	pgraph $< | jq -r 'select(.type=="edge")|[.from,.to]|@tsv' > $@
	pgraph $< | jq -r 'select(.type=="node" and .properties.alias)|[.properties.alias[0],.id]|@tsv' >> $@

