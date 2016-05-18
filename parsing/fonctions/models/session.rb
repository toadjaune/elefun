require 'neo4j'
require 'date'

class Session
  #Appartient à un User et regroupe un ensemble de Page visitées
  include Neo4j::ActiveNode

  property :name, type: String, constraint: :unique
  property :agent, type: String
  property :ip, type: String
  
  property :start, type: DateTime
  property :end, type: DateTime
  
  property :video_viewed, type: Integer, default: 0
  property :quiz_answered, type: Integer, default: 0
  property :page_visited, type: Integer, default: 0
  property :forum_visited, type: Integer, default: 0
  property :forum_posted, type: Integer, default: 0

  validates_presence_of :name

  has_one :in, :user, type: :user
  has_many :out, :pages, rel_class: :Event

  def set_view
    self.video_viewed = self.query_as(:s).match('s-[:event]->(v:Video)').count('DISTINCT v')
    self.save
  end

  def set_quiz
    self.quiz_answered = self.query_as(:s).match('s-[:event]->(:Question)<--(q:Quiz)').count('DISTINCT q')
    self.save
  end

  def set_visit
    self.forum_visited = self.query_as(:s).match('s-[e:event]->(:Fil)').where(e:{type: 'forum_visit'}).count(:e)
    self.save
  end

  def set_posts
    self.forum_posted = self.query_as(:s).match('s-[e:event]->(:Fil)').where(e:{type: 'forum_post'}).count(:e)
    self.save
  end

  def end_inactivity
    self.name += rand(36**10).to_s(36)
    self.save
  end
end
