require 'neo4j'

class Fil < Page
  #blabla
  include Neo4j::ActiveNode

  property :time, type: DateTime

  property :message, type: String
  property :fil_type, type: String
  property :category_id, type: String

  has_many :out, :responses, type: :response
  has_many :in, :users, rel_class: :info_fil
  #has_one :in, :sess_creation, type: :session

  def set(params)
    super.set(params)
    self.time = params['time']
    self.message = params['event']['body']
    self.fil_type = params['event']['thread_type']
    self.category_id = params['event']['category_id']
    u,s = Parser.get_session(params['session'])
    s.add_posts
    self.sessions << s
    self.save
    i=self.users.where()


  end

  def set_discuss(params)
    self.time = params['time']
    self.display_name = params['event']['POST']['title'].pop
    self.message = params['event']['POST']['body'].pop
    self.fil_type = params['event']['POST']['thread_type'].pop
    u,s = Parser.get_session(params['session'])
    s.add_posts
    self.sessions << s
    self.save
  end

end
