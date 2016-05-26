class Fil < Page
  #blabla
  include Neo4j::ActiveNode

  property :time, type: DateTime

  property :message, type: String
  property :fil_type, type: String
  property :category_id, type: String

  has_many :out, :responses, type: :response

  def set(params)
    self.myid = params['event']['id']
    self.time = params['time']
    self.message = params['event']['body'].encode("UTF-8")
    self.display_name = params['event']['title'].encode("UTF-8")
    self.fil_type = params['event']['thread_type']
    self.category_id = params['event']['category_id']
    self.save
  end

  def set_discuss(params)
    self.time = params['time']
    self.display_name = params['event']['POST']['title'].pop.encode("UTF-8")
    if self.display_name.empty?
      self.display_name = "thread"
    end
    self.message = params['event']['POST']['body'].pop.encode("UTF-8")
    self.fil_type = params['event']['POST']['thread_type'].pop
  end

end
