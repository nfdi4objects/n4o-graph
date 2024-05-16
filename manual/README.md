## Handbuch [![Status](https://github.com/nfdi4objects/n4o-graph/actions/workflows/quarto-publish.yml/badge.svg)](https://github.com/nfdi4objects/n4o-graph/actions/workflows/quarto-publish.yml)

Das Handbuch zum Knowledge Graphen ist mit [quarto](https://quarto.org/)
erstellt. Die Konfiguration liegt in [`_quarto.yml`](_quarto.yml) und die
einzelnen Kapitel in Quarto-Markdown-Syntax in Dateien mit der Endung `.qmd`.

Die HTML-Version des Handbuch kann lokal mit Aufruf von `quarto render` in
diesem Ordern oder mit `make docs` im Wurzelverzeichnis aktualisiert werden und
liegt anschließend im Verzeichnis `docs`. Die publizierte Version unter
<https://nfdi4objects.github.io/n4o-graph/> wird bei GitHub automatisch aus dem
`main` Branch erzeugt.

Das Handbuch enthält eine Beschreibung der Architektur und Workflows des
Knowledge Graphen und Abfrage-Beispiele in Cypher und SPARQL in Python und
JavaScript.
