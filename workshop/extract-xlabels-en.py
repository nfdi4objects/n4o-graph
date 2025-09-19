import rdflib
import sys

g = rdflib.Graph()
g.parse(sys.stdin)

knows_query = """
SELECT DISTINCT ?id ?label
WHERE { ?id <http://www.w3.org/2008/05/skos-xl#prefLabel> [ <http://vocab.getty.edu/ontology#term> ?label ] 
FILTER (lang(?label) = 'en')}
"""

qres = g.query(knows_query)

with open('result.nt', 'w') as f:
	for row in qres:
		print(f'{rdflib.URIRef(row.id).n3()} <http://www.w3.org/2004/02/skos/core#prefLabel> {row.label.n3()} .', file=f)
