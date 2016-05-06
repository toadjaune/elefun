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

file1 = File.new('data/20003S02/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized','r')
file2 = File.new('event_type_spreadsheet','w')
#file = File.new('data/20003S02/enrollments','r')

h = Hash.new(0)

file1.each do |l|
  line = JSON.parse(l)
  h[line['event_type']] += 1
end

h.each do |key, value|
  file2.write(key.to_s + " : " + value.to_s + "\n")
end
