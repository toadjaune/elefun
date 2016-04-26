require 'neo4j'

class Response
  #réponse à blabla
  include Neo4j::ActiveNode


  property :myid, type: String
  property :time, type: DateTime

  property :message, type: String

  property :category_id, type: String

  has_one :out, :fil, type: :fil
  has_many :in, :comments, type: :comment

  # ajout des sessions...

  # et des cours auxquels ça fait référence

  def set(params)
    self.myid = params['event']['id']
    self.time = params['time']
    self.message = params['event']['body']
    self.category_id = params['event']['category_id']

    f = Fil.as(:t).where(myid: params['event']['discussion']['id']).pluck(:t).first
    if f
      f.responses << self
    end
  end

  def set_discuss(params, f)
    self.time = params['time']
    self.message = params['event']['POST']['body'].pop
    if f
      f.responses << self
    end
  end

end
