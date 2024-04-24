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

LIDO-XML-Daten werden mit Hilfe von [X3ML](https://github.com/isl/x3ml)
konvertiert. Die Konvertierung von RDF-Daten, nachdem diese mit
[n4o-rdf-import](https://github.com/nfdi4objects/n4o-rdf-import)
angenommen wurden, steht noch aus.

![](data-flow.svg)

## Datenmodell

Als Sammlungsübergeifendes Datenmodell wird CIDOC-CRM mit Erweiterung durch die DFI4Objects Core Ontologie (N4O) verwendet.

- Knoten erhalten als Knoten-Label die entsprechenden CRM- bzw. N4O Klassen.
  Dabei werden Leerzeichen und Sonderzeichen durch Unterstrich ersetzt, also
  z.B.

  - `E22_Human_Made_Object` für
  [E22 Human-Made Object](https://cidoc-crm.org/html/cidoc_crm_v7.1.3_with_translations.html#E22)

- Zwischenzeitlich gelöschte und umbenannte Klassen können weiterhin verwendet
  werden, allerdings werden diese durch [Expansion](#expansion) auf die neueste
  Form gemappt.

*Das Datenmodell beschränkt sich noch auf Klassen ohne Properties!*

Die Klassenhierarchien als Diagramm

  - [CIDOC-CRM (alle Versionen)](crm-classes.svg)
  - [N4O (bis zur ersten CRM-Klasse)](n4o-classes.svg)
  - [beide zusammen](n4o-all-classes.svg)

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

