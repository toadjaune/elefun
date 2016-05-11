require 'neo4j'

class Quiz < Page
  #Représente les différentes questions des quiz du cours
  include Neo4j::ActiveNode
  
end