async function cypherQuery(cypher) {
  const url = "https://graph.gbv.de/api?" + new URLSearchParams({cypher})
  return fetch(url).then(async response => {
    const data = await response.json()
    if (!response.ok) throw new Error(`${data.error}: ${data.message}`)
    if (!Array.isArray(data)) throw new TypeError("Malformed API response")
    return data
  })
}
