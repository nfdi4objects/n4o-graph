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

## Ausblick

Das Datenmodell besteht zunächst nur aus einer Klassenhierarchie. Diese muss
noch erweitert werden um

- Properties
- Identifier (für Normdaten-Identifier siehe <https://github.com/nfdi4objects/n4o-terminologies>)
- Informationen über Sammlungen aus denen die Daten und Objekte stammen
  (siehe <https://github.com/nfdi4objects/n4o-databases> und
  <https://github.com/nfdi4objects/n4o-rdf-import>)
- Ontologien und Vokabulare

## Handbuch

Dieses Repository enthält als Handbuch eine Einführung in den Aufbau und die
Nutzung des NFDI4Objects Knowledge Graphen. Das Handbuch ist mit
[quarto](https://quarto.org/) erstellt und enthält Code-Beispiele Cypher,
SPARQL und Python. Quelltext des Handbuch sind alle Dateien mit der Endung
`.qmd`.

Zur Aktualisierung der HTML-Version des Handbuch wird neben quarto jupyter notebook benötigt (Installation z.B. via `sudo apt install jupyter-notebook`). Anschließend kann es mit `quarto render` aktualisiert werden. 

