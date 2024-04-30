# NFDI4Objects Property Graph

Dieses Repositoriy enthält Skripte und Dokumentation zur Erstellung und
Management eine Knowledge Graphen der von NFDI4Objects TA5 als Property-Graph
umgesetzt wird.

*Zur Einführung in Property Graphen [siehe dieser Artikel](https://jakobib.github.io/pgraphen2024/) <https://doi.org/10.5281/zenodo.10971391>.*

## Technische Voraussetzungen

- Unix-Shell und Standard-Tools
- Docker
- [pgraphs](https://www.npmjs.com/package/pgraphs)
- [mermaid-cli](https://www.npmjs.com/package/@mermaid-js/mermaid-cli)
- jq
- Perl
- Python3 mit [Package neo4j](https://pypi.org/project/neo4j/):
  `pip install -r requirements.txt --break-system-packages` ?

## Datenfluss

siehe [Handbuch](architecture.qmd).

## Expansion

Da Property-Graphen im Gegensatz zu RDF keine Inferenz-Regeln beinhalten und
weil Inferenz-Regeln sowieso umständlich sind, werden die Daten im
Property-Graphen *expandiert*.  Grundlage ist ein eigener Property-Graph mit
der Klassenhierarchie des CIDOC-CRM Datenmodell samt zwischenzeitlich
umbenannter oder veralteter Klassen in der Datei `crm-classes.pg` (siehe
[SVG-Diagram](crm-classes.svg)). Der Graph aller Klassen enthält Informationen
darüber welche Klassen sich aus einer anderen ergeben, z.B.

- `E22_Man_Made_Object` => `E22_Human_Made_Object` (renamedTo)
- `E50_Date` => `E41_Appellation` (replacedBy)
- `E7_Activity`=> `E5_Event` (superClass)

Aus diesen Daten wird die Expansionstabelle [`crm-expand.txt`](crm-expand.txt)
erzeugt, z.B.:

- `E22_Human_Made_Object` => `E22`, `E71`, `E70`, `E24` `E77` und `E1`

Zum Ausführen der Expansion: 

~~~sh
./pg-expand-labels.py [Neo4j login file] < crm-expand.txt
~~~

Ohne Konfigurationsdatei für Neo4J werden Cypher-Kommandos ausgegeben. Mit
Konfiguration wird die Expansion in der betreffenden Neo4J-Datenbank
ausgeführt.

Nach der Expansion ist die Abfrage nach allen Knoten mit einem bestimmten Label
wie z.B. `E22_Human_Made_Object` möglich oder nach allen Knoten, die direkt
oder indirekt er Klasse `E22` angehören.

*Die Expansion von zusätzlichen Klassen der [NFDI4Objects Core
Ontology](https://github.com/nfdi4objects/n4o-core-ontology) auf CIDOC-CRM ist
auf die gleiche Weise möglich aber noch nicht umgesetzt.*

## Ausblick

Das Datenmodell besteht zunächst nur aus einer Klassenhierarchie. Diese muss
noch erweitert werden um

- Properties
- Identifier (für Normdaten-Identifier siehe <https://github.com/nfdi4objects/n4o-terminologies>)
- Informationen über Sammlungen aus denen die Daten und Objekte stammen
  (siehe <https://github.com/nfdi4objects/n4o-databases> und
  <https://github.com/nfdi4objects/n4o-rdf-import>)

## Handbuch

Dieses Repository enthält als Handbuch eine Einführung in den Aufbau und die
Nutzung des NFDI4Objects Knowledge Graphen. Das Handbuch ist mit
[quarto](https://quarto.org/) erstellt und enthält Code-Beispiele in Python.
Quelltext des Handbuch sind alle Dateien mit der Endung `.qmd`.

Zur Aktualisierung der HTML-Version des Handbuch wird neben quarto jupyter notebook benötigt (Installation z.B. via `sudo apt install jupyter-notebook`). Anschließend kann es mit `quarto render` aktualisiert werden. 
