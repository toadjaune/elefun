#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require 'date'

require_relative 'models/event'
require_relative 'models/user'
require_relative 'models/session'
require_relative 'models/page'

db = Neo4j::Session.open(:server_db)

#fichier bac à sable pour tester tout et rien

#on compte ce qu'on arrive à parser parmi les events browser en première partie en parsant sur le :path puis sur le event[:id]

file = File.new('data/20003S02/browser_events', 'r')

nb_i4x = 0
nb_page = 0
nb_event_id = 0
total = 0

file.each do |l|
  line = JSON.parse(l)
  #id = line['event']['id']
  if line['event'].is_a?(Hash) and id = line['event']['id']
    if id.match '^i4x:'
      puts("#{total}| i4x  : " + id.split('/').last)
      nb_i4x += 1
    else
      puts("#{total}| id   : " + id.split('-').last)
      nb_event_id += 1
    end
  else
    puts("#{total}| page : " + line['page'].split('/').last)
    nb_page += 1
  end
  total += 1
end
  
puts("i4x : #{nb_i4x}/#{total} | #{1.0*nb_i4x/total*100}%")
puts("page : #{nb_page}/#{total} | #{1.0*nb_page/total*100}%")
puts("event id : #{nb_event_id}/#{total} | #{1.0*nb_event_id/total*100}%")

