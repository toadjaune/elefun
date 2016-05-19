require 'neo4j'
require 'date'

class Week < Etiquetable
  include Neo4j::ActiveNode
  
  property :date_debut, type: DateTime
  property :date_fin, type: DateTime
  
  validates_presence_of :date_debut
  validates_presence_of :date_fin
 end
