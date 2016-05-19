require 'neo4j'

class Page < Etiquetable
  #Représente les différentes pages du cours
  include Neo4j::ActiveNode
  
  property :display_name, type: String
  property :graded, type: Boolean, default: false
  property :forma, type: String, default: ""
  property :myid, type: String,  constraint: :unique
  property :depth, type: Integer
  property :week, type: String
  
  validates :display_name, presence: true
  
  has_one :in, :parent, type: :page, model_class: :Page
  has_many :out, :children, type: :page, model_class: :Page
  
  has_many :in, :sessions, rel_class: :Event

	
  def set(params, depth, week)
    self.myid = params['id'].split("/").last
    self.type = params['type']
    self.display_name = params['display_name']
    self.graded = params['graded']
    self.forma = params['format']
    self.depth = depth
    if params['type'] != "chapter"
      #les pages de types chapter sont les semaines
      self.week = week
    end
  end
end
