class Week < Etiquetable
  include Neo4j::ActiveNode
  
  has_many :in, :users, rel_class: :Info
  has_many :in, :pages, type: :page
  
  property :number, type: Integer
  property :name, type: String
  
  property :date_debut, type: DateTime
  property :date_fin, type: DateTime
  
  #validates_presence_of :date_debut
  #validates_presence_of :date_fin
 end
