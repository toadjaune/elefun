require 'neo4j'
require 'date'

class Session
  #Appartient à un User et regroupe un ensemble de Page visitées
  include Neo4j::ActiveNode
  
  property :name, type: String, constraint: :unique
  property :agent, type: String
  property :ip, type: String
  property :date_debut, type: DateTime
  property :date_fin, type: DateTime
  property :forum_vu, type: Integer, default: 0
  property :video_vu, type: Integer, default: 0
  property :forum_msg, type: Integer, default: 0
  property :quizz_fait, type: Integer, default: 0
  property :page_vues, type: Integer, default: 0
  
  validates_presence_of :name
  
  has_one :in, :user, type: :user
  has_many :out, :pages, rel_class: :Event

  def end
    self.name += rand(36**10).to_s(36)
    self.save
  end
 end