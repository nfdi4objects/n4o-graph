.PHONY: docs

default: images crm-expand.txt

images: manual/img/data-flow.svg manual/img/crm-classes.svg manual/img/nomisma-classes.svg manual/img/n4o-classes.svg manual/img/n4o-all-classes.svg

docs:
	cd manual && quarto render

manual/img/data-flow.svg: data-flow.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

manual/img/crm-classes.svg: crm-classes.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

manual/img/nomisma-classes.svg: nomisma-classes.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

manual/img/n4o-classes.svg: n4o-classes.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

nmanual/img/n4o-all-classes.svg: crm-classes.pg n4o-classes.pg
	cat $^ | pgraph --html -t mmd | mmdc -i - -o $@

crm-expand.txt: crm-expand.tsv
	./expansion-list.pl < $< | sort > $@

crm-expand.tsv: crm-classes.pg
	pgraph $< | jq -r 'select(.type=="edge" and any(.labels[]; .=="replacedBy" or .=="superClass"))|[.from,.to]|@tsv' > $@
	pgraph $< | jq -r 'select(.type=="node" and .properties.alias)|[.properties.alias[0],.id]|@tsv' >> $@


