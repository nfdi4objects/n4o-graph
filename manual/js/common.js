async function sparqlQuery(body) {
  return fetch('https://graph.nfdi4objects.net/api/sparql', {method: "POST", body, headers: { "Content-Type": "application/sparql-query" }}).then(async response => {
    const data = await response.json()
    if (!response.ok) throw new Error(`${data.error}: ${data.message}`)
    if (!Array.isArray(data)) throw new TypeError("Malformed API response")
    return data
  })
}
