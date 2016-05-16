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

db = Neo4j::Session.open(:server_db)

#fichier bac à sable pour tester tout et rien

#on compte ce qu'on arrive à parser parmi les events browser en première partie en parsant sur le :path puis sur le event[:id]

#question = Quiz.find_by(myid: "8367920c39f34e06bd5c64394f3a11d8")
file = File.new('data/20003S02/test','r')

$auteur = 'ENSCachan'
$id_cours = '20003S02'
$periode = 'Trimestre_1_2015'

s = Session.all
s.each do |sess|
  sess.set_view
  sess.set_quiz
end