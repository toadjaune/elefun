#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require 'date'

require_relative 'models/event'
require_relative 'models/user'
require_relative 'models/session'
require_relative 'models/page'
require_relative 'models/fil'
require_relative 'models/response'
require_relative 'models/comment'

db = Neo4j::Session.open(:server_db)

#fichier bac à sable pour tester tout et rien

#on compte ce qu'on arrive à parser parmi les events browser en première partie en parsant sur le :path puis sur le event[:id]

f = Fil.first
puts(f.myid)
f.responses.each do |c|
  print 1
end

r = Response.first
puts(r.fil.myid)