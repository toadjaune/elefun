require 'neo4j'

class Quiz < Page
  #Représente un des quiz du cours
  include Neo4j::ActiveNode
  
  has_many :in, :sessions, rel_class: :Result
  
  def to_s
    return "[QUIZ] name: "+self.display_name
  end
end