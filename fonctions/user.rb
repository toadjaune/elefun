require 'neo4j'

class User
  include Neo4j::ActiveNode
  
  property :username, type: String
  property :user_id, type: Integer
  
  validates_presence_of :username
  
  has_many :out, :sessions, type: :session
end