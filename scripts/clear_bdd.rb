#!/usr/bin/env ruby

require_relative 'common'
#while $db.query("MATCH (n) RETURN n").count(:n) > 0
$db.query("MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE r, n")
#end
puts("DB cleared !")
$db.close()
