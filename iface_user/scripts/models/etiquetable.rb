require 'neo4j'

class Etiquetable
  include Neo4j::ActiveNode


  property :mooc, type: String
end
