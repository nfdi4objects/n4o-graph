import fs from "fs"
import { pgformat, ParsingError } from "pgraphs"

const graph = pgformat.pg.parse(fs.readFileSync(`voc/crm-all-classes.pg`).toString())

console.log(
`@prefix crm: <http://www.cidoc-crm.org/cidoc-crm/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
`)

const classes = []

function emitClass(id) {
    if (id in classes) return
    console.log(`crm:${id} a owl:Class .`)
    classes[id] = true
}

for (let { from, to, labels } of graph.edges) {
    emitClass(from)
    if (labels[0] === "replacedBy") {
      console.log(`crm:${from} owl:deprecated true .`)
    }
    if (labels[0] == "superClass" || labels[0] == "replacedBy") {
      console.log(`crm:${from} rdfs:subClassOf crm:${to} .`)
    }
}

for (let { to } of graph.edges) { emitClass(to) }
for (let { id } of graph.nodes) { emitClass(id) }
