.PHONY: docs

default: data-flow.svg crm-classes.svg nomisma-classes.svg crm-expand.txt n4o-classes.svg n4o-all-classes.svg

data-flow.svg: data-flow.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

crm-classes.svg: crm-classes.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

nomisma-classes.svg: nomisma-classes.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

n4o-classes.svg: n4o-classes.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

n4o-all-classes.svg: crm-classes.pg n4o-classes.pg
	cat $^ | pgraph --html -t mmd | mmdc -i - -o $@

crm-expand.txt: crm-expand.tsv
	./expansion-list.pl < $< | sort > $@

crm-expand.tsv: crm-classes.pg
	pgraph $< | jq -r 'select(.type=="edge" and any(.labels[]; .=="replacedBy" or .=="superClass"))|[.from,.to]|@tsv' > $@
	pgraph $< | jq -r 'select(.type=="node" and .properties.alias)|[.properties.alias[0],.id]|@tsv' >> $@

docs:
	cd manual && quarto render
