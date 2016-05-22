#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require 'date'

require_relative 'models/event'
require_relative 'models/user'
require_relative 'models/session'
require_relative 'models/page'
require_relative 'models/video'
require_relative 'models/fil'
require_relative 'models/response'
require_relative 'models/comment'
require_relative 'models/question'
require_relative 'models/result'
require_relative 'models/quiz'
require_relative 'parsers/forum'

db = Neo4j::Session.open(:server_db)

#fichier bac à sable pour tester tout et rien

#on compte ce qu'on arrive à parser parmi les events browser en première partie en parsant sur le :path puis sur le event[:id]

#question = Quiz.find_by(myid: "8367920c39f34e06bd5c64394f3a11d8")

file = File.new('data/20003S02/left_to_parse','r')

file2 = File.new('event_types', 'w')

h= Hash.new(0)

file.each do |line|
  l = JSON.parse(line.match('{.*}$')[0])
  h[l['event_type']] += 1
end

h.each do |event, nb|
  file2.puts("#{event} | #{nb}")
end
