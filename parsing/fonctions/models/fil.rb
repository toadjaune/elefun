require 'neo4j'

class Fil
  #blabla 
  include Neo4j::ActiveNode

  property :myid, type: String, constraint: :unique
  property :time, type: DateTime

  property :title, type: String
  property :message, type: String
  property :fil_type, type: String

  property :category_id, type: String

  has_many :in, :responses, type: :response

  #has_one :in, :sess_creation, type: :session
  #has_many :in, :sessions, type: :session

  #manque cet élément (à voir si utile)
  #has_one :out, :page, type: :page

  def set(params)
    self.myid = params['event']['id']
    self.time = params['time']
    self.title = params['event']['title']
    self.message = params['event']['body']
    self.fil_type = params['event']['thread_type']
    self.category_id = params['event']['category_id']
  end

  def set_discuss(params)
    self.time = params['time']
    self.title = params['event']['POST']['title'].pop
    self.message = params['event']['POST']['body'].pop
    self.fil_type = params['event']['POST']['thread_type'].pop

    #s = Session.as(:s).where(name: params['session']).pluck(:s).first
    #if s.nil?
    #	s = Session.create(name: params['session'], agent: params['agent'], debut_time: params['time'])
    #end
    #self.sess_creation << s
  end
end
