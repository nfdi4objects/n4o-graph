import sys
from neo4j import GraphDatabase
import json
"""
The first label in each line will get expanded with every other label in that line. Labels should be split by a space.
If there's a json file with your Neo4j login provided as an argument, it directly executes the cypher queries. Otherwise it prints out the cypher_queries.
python3 crm-expand.py [Neo4j login file] < [expand file]
"""
#Read the expand file from stdin and create the cypher queries.
cypher_queries = ""
for line in sys.stdin:
 parts = line.strip().split()
 a = parts[0]
 b = ':'.join(parts[1:])
 cypher_queries += (f"MATCH (n:{a}) SET n:{b};\n")
cypher_queries = cypher_queries[:-1]


try:
#Read the json file and enter the information.
 neo4j_file = sys.argv[1]
 with open(neo4j_file, 'r') as file:
  neo4j_login = json.loads(file.read())
 uri = neo4j_login.get("uri")
 username = neo4j_login.get("user")
 password = neo4j_login.get("password")
 driver = GraphDatabase.driver(uri, auth=(username, password))
 nodes_changed = 0
 labels_added = 0
 #Execute the queries. Also count how many were successfully changed a node and how many labels were added in total.
 with driver.session() as session:
  for query in cypher_queries.split('\n'):
   result = session.run(query).consume().counters
   if getattr(result, '_contains_updates', False):
    nodes_changed += 1
   labels_added += getattr(result, 'labels_added', 0)
  print("Nodes changed=", nodes_changed)
  print("Labels added=", labels_added)
 driver.close()
#No json file provided. Print out the queries.
except IndexError:
 print(cypher_queries)
