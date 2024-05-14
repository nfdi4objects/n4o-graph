import fs from "fs"
import { pgformat } from "pgraphs"

const pg = process.argv.slice(2).map(file => fs.readFileSync(file).toString()).join("\n")
const { nodes, edges } = pgformat.pg.parse(pg)

const broader = {}
const isBroader = (from, to) => {
  if (!from || !to) return
  from in broader
    ? broader[from].add(to)
    : broader[from] = new Set([to])
  broader[to] ||= new Set()
}

const crmId = id => {
  const match = id.match(/^([EP][0-9]+)_/)
  return match ? match[1] : null
}

for (let { from, to, labels } of edges) {
  if (labels.find(l => l == "replacedBy" || l == "superClass" || l == "superProperty")) {
    to = crmId(to) || to
    isBroader(from, to)
    isBroader(crmId(from), to)
  }
}

for (let { id, properties } of nodes) {
  if (properties.alias)     // e.g. E22_Man_Made_Object => E22
    isBroader(properties.alias[0], crmId(id) || id)
  isBroader(id, crmId(id))  // e.g. E52_Time_Span => E52
}

// calculation of transitive closure

const names = Object.keys(broader).sort()                       // id => name
const ids = Object.fromEntries(names.map((name,i) => [name,i])) // name => id

const reach = Array.from(Array(names.length), () => names.map(() => false))

for (let from in broader)
  for (let to of broader[from])
    reach[ids[from]][ids[to]] = true

for (let k=0; k<names.length; k++)
  for (let i=0; i<names.length; i++)
    for (let j=0; j<names.length; j++)
      reach[i][j] ||= (reach[i][k] && reach[k][j])

// emit result

for (let i=0; i<names.length; i++) {
  const from = names[i]
  if (from.match(/^E\d+$/)) continue // these are not used directly
  const to = names.filter((name,j) => i!=j && reach[i][j])
  if (to.length)
    console.log([from, ...to].join(" "))
}
