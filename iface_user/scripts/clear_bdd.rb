#!/usr/bin/env ruby

require_relative 'common'

db.query("MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE r, n")  
puts("DB cleared !")
db.close()
