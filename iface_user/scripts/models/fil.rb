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
    self.myid = params['event']['id']
    self.time = params['time']
    self.message = params['event']['body'].encode("UTF-8")
    self.display_name = params['event']['title'].encode("UTF-8")
    self.fil_type = params['event']['thread_type']
    self.category_id = params['event']['category_id']
    self.save
    i=self.users.where()
  end

  def set_discuss(params)
    self.time = params['time']
    self.display_name = params['event']['POST']['title'].pop.encode("UTF-8")
    self.message = params['event']['POST']['body'].pop.encode("UTF-8")
    self.fil_type = params['event']['POST']['thread_type'].pop
    u,s = Parser.get_session(params)
    s.add_posts
    #if s.nil?
    #	s = Session.create(name: params['session'], agent: params['agent'], debut_time: params['time'])
    #end
    self.sessions << s
    self.save
  end

end
