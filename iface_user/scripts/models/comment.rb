require 'neo4j'

class Comment < Etiquetable
  #commentaire sur du blabla
  include Neo4j::ActiveNode


  property :myid, type: String
  property :time, type: DateTime

  property :message, type: String

  property :category_id, type: String

  has_one :out, :response, type: :response

  # ajout des sessions...

  # et des cours auxquels ça fait référence

  def set(params)
    self.myid = params['event']['id']
    self.time = params['time']
    self.message = params['event']['body']
    self.category_id = params['event']['category_id']
    r = Response.as(:r).where(myid: params['event']['response']['id']).pluck(:r).first
    if r
      r.comments << self
    end
  end

  def set_discuss(params, r)
    self.time = params['time']
    self.message = params['event']['POST']['body'].pop
    if r 
      r.comments << self
    end
  end

end
