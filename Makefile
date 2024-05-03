.PHONY: docs

default: images crm-expand.txt

images: manual/img/data-flow.svg manual/img/crm-classes.svg manual/img/nomisma-classes.svg manual/img/n4o-classes.svg manual/img/n4o-all-classes.svg

docs:
	cd manual && quarto render

manual/img/data-flow.svg: data-flow.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

manual/img/crm-classes.svg: voc/crm-classes.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

manual/img/nomisma-classes.svg: voc/nomisma-classes.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

manual/img/n4o-classes.svg: voc/n4o-classes.pg
	pgraph $< --html -t mmd | mmdc -i - -o $@

nmanual/img/n4o-all-classes.svg: voc/crm-classes.pg voc/n4o-classes.pg
	cat $^ | pgraph --html -t mmd | mmdc -i - -o $@

crm-expand.txt: crm-expand.tsv
	./expansion-list.pl < $< | sort > $@

crm-expand.tsv: voc/crm-classes.pg
	pgraph $< | jq -r 'select(.type=="edge" and any(.labels[]; .=="replacedBy" or .=="superClass"))|[.from,.to]|@tsv' > $@
	pgraph $< | jq -r 'select(.type=="node" and .properties.alias)|[.properties.alias[0],.id]|@tsv' >> $@


