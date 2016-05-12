require 'neo4j'
require 'date'

class Week
  include Neo4j::ActiveNode
  
  has_many :in, :users, rel_class: :Info
  
  property :date_debut, type: DateTime
  property :date_fin, type: DateTime
  
  validates_presence_of :date_debut
  validates_presence_of :date_fin
 end