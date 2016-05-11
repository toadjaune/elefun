require 'neo4j'

class Video < Page
  #Représente les différentes pages du cours
  include Neo4j::ActiveNode
  
  
  property :views, type: Integer, default: 0
  
  def add_view
    self.views += 1
    self.save
  end
end