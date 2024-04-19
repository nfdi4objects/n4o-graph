default: data-flow.svg crm-classes.svg crm-expand.csv

data-flow.svg: data-flow.mmd
	mmdc -i $< -o $@

data-flow.mmd: data-flow.pg
	pgraph --html $< $@

crm-classes.svg: crm-classes.mmd
	mmdc -i $< -o $@

crm-classes.mmd: crm-classes.pg
	pgraph --html $< $@

crm-expand.csv: crm-classes.pg
	pgraph $< | jq -r 'select(.type=="edge")|[.to,.from]|@tsv' > $@
	pgraph $< | jq -r 'select(.type=="node" and .properties.alias)|[.id,.properties.alias[0]]|@tsv' >> $@

