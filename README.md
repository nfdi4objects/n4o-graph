# NFDI4Objects Property Graph

Dieses Repositoriy enthält Skripte und [Dokumentation](#handbuch) zur
Erstellung, Management und Nutzung des NFDI4Objects Knowledge Graphen von TA5.

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

## Handbuch

Das Verzeichnis [`manual`](manual) enthält den Quelltext des Handbuchs für den
NFDI4Objects Knowledge Graphen (Quarto Markdown-Dateien mit der Endung `.qmd`).
Das Handbuch ist mit [quarto](https://quarto.org/) erstellt und enthält
Code-Beispiele in Cypher, SPARQL und Python.

Zur Aktualisierung der HTML-Version des Handbuch wird außerdem Jupyter Notebook
benötigt (Installation z.B. via `sudo apt install jupyter-notebook`).
Anschließend kann es mit `quarto render` im Ordern `manual` (bzw. `make docs`
im Wurzelverzeichnis) aktualisiert werden. Die HTML-aktualisierte HTML-Version
wird ins [`docs`](docs) geschrieben und von dort unter Anderem unter
<https://nfdi4objects.github.io/n4o-property-graph/> veröffentlicht.

