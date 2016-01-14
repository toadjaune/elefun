require 'neo4j'

class Page
  include Neo4j::ActiveNode
  
  
  property :type, default: 'unknown'
  property :display_name
  property :graded, type: Boolean, default: false
  property :forma, type: String, default: ""
  property :myid, constraint: :unique
  
  validates :display_name, presence: true
  
  has_one :in, :parent, type: :page, model_class: :Page
  has_many :out, :children, type: :page, model_class: :Page
  
  def set(params)
    self.myid = params['id'].split("/").last
    self.type = params['type']
    self.display_name = params['display_name']
    self.graded = params['graded']
    self.forma = params['format']
  end
end