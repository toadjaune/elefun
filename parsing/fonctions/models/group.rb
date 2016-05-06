require 'neo4j'

class Group
  #Sert à regrouper les Pages du cours par thème/fonctions
  # ex : semaine, quiz, vidéos
  include Neo4j::ActiveNode
  
  property :name, type: String
  
  validates_presence_of :name
  
  has_many :out, :pages, type: :page
  
end