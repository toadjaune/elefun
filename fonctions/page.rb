require 'neo4j'

class Page
  include Neo4j::ActiveNode
  
  property :type, default: 'unknown'
  property :display_name
  property :graded, type: Boolean, default: false
  property :forma, type: String, default: ""
  property :id, constraint: :unique
  
  validates :display_name, presence: true
  
  has_one :in, :parent, type: :page, model_class: :Page
  has_many :out, :children, type: :page, model_class: :Page
end