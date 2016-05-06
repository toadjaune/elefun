#!/usr/bin/env ruby
require 'neo4j'

db = Neo4j::Session.open(:server_db)
db.query("MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE r, n")
puts("DB cleared !")
db.close()
