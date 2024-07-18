async function cypherQuery(cypher) {
  const url = "https://graph.gbv.de/api?" + new URLSearchParams({cypher})
  // TODO: detect errors and show message
  return fetch(url).then(res => res.json())
}
