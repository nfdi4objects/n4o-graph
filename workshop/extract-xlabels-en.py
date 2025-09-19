import rdflib
import sys

sparql = """
SELECT DISTINCT ?id ?label {
  ?id <http://www.w3.org/2008/05/skos-xl#prefLabel> [
    <http://vocab.getty.edu/ontology#term> ?label 
  ] 
  FILTER (lang(?label) = 'en')
}
"""

g = rdflib.Graph()
g.parse(sys.stdin)

for row in g.query(sparql):
	print(f'{rdflib.URIRef(row.id).n3()} <http://www.w3.org/2004/02/skos/core#prefLabel> {row.label.n3()} .')
