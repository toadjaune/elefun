class Etiquetable
  include Neo4j::ActiveNode

  property :mooc, type: String

  before_save :set_mooc_id, on: :create

  def set_mooc_id
    self.mooc = $id_cours
  end
end
