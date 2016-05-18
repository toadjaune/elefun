require 'neo4j'

class Fil < Page
  #blabla 
  include Neo4j::ActiveNode

  property :time, type: DateTime

  property :message, type: String
  property :fil_type, type: String
  property :category_id, type: String
  property :vues, type: Integer, default: 0
  has_many :out, :responses, type: :response
  has_one :in, :user, type: :user
  #has_one :in, :sess_creation, type: :session

  def set(params)
    super.set(params)
    self.time = params['time']
    self.message = params['event']['body']
    self.fil_type = params['event']['thread_type']
    self.category_id = params['event']['category_id']
          u,s = Parser.get_session(params['session'])
    self.user = u
    self.sessions << s
    self.save
  end

  def set_discuss(params)
    self.time = params['time']
    self.display_name = params['event']['POST']['title'].pop
    self.message = params['event']['POST']['body'].pop
    self.fil_type = params['event']['POST']['thread_type'].pop
    u,s = Parser.get_session(params['session'])
    self.user = u
    #if s.nil?
    #	s = Session.create(name: params['session'], agent: params['agent'], debut_time: params['time'])
    #end
    self.sessions << s
    self.save
  end
  
  def add_views()
    self.vues +=1
  end
  
end
