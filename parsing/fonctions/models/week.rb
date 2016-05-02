require 'neo4j'
require 'date'

class Week
  include Neo4j::ActiveNode
  
  property :date_debut, type: DateTime
  property :date_fin, type: DateTime
