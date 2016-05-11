require 'neo4j'
require_relativ 'info'

class User
  #Un utilisateur ayant été vu au moins une fois pendant le cours
  include Neo4j::ActiveNode
  
  property :username, type: String
  property :user_id, type: Integer
 
  property :name, type: String
  property :password, type: String
  property :email, type: String
  property :mailing_address, type: String
  property :csrfmiddlewaretoken, type: String
 
  property :gender, type: String
  property :country, type: String
  property :city, type: String
  property :year_of_birth, type: Integer
  property :level_of_education, type: String
  
  property :goals, type: String
  
  property :terms_of_service, type: Boolean
  property :honor_code, type: Boolean
  
  validates_presence_of :username
  
  has_many :out, :informations, type: Info
  has_many :out, :sessions, type: :session
  
  def set(params)
    self.username = params['username'][0]
    self.name = params['name']
    self.password = params['password']
    self.email = params['email']
    self.mailing_address = params['mailing_address']
    self.csrfmiddlewaretoken = params['csrfmiddlewaretoken'][0]
    
    self.gender = params['gender'][0]
    self.country = params['country'][0]
    self.city = params['city'][0]
    self.year_of_birth = params['year_of_birth'][0]
    self.level_of_education = params['level_of_education'][0]
    
    self.goals = params['goals'][0]
    
    self.terms_of_service = params['terms_of_service']
    self.honor_code = params['honor_code']
  end
  
  def to_s
    return "username : "+self.username
  end
end
