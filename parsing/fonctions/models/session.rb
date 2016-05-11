require 'neo4j'
require 'date'

class Session
  #Appartient à un User et regroupe un ensemble de Page visitées
  include Neo4j::ActiveNode
  
  property :name, type: String, constraint: :unique
  property :agent, type: String
  property :ip, type: String
  property :date_debut, type: DateTime
  property :date_fin, type: DateTime
  
  validates_presence_of :name
  
  has_one :in, :user, type: :user
  has_many :out, :pages, rel_class: :Event

  end