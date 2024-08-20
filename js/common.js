async function cypherQuery(query) {
  const url = "https://graph.gbv.de/api/cypher?" + new URLSearchParams({query})
  return fetch(url).then(async response => {
    const data = await response.json()
    if (!response.ok) throw new Error(`${data.error}: ${data.message}`)
    if (!Array.isArray(data)) throw new TypeError("Malformed API response")
    return data
  })
}
