class Session
  include Neo4j::ActiveNode
  #Appartient à un User et regroupe un ensemble de Page visitées
  include Regroup::Sessions

  #Données
  property :name, type: String
  property :agent, type: String
  property :ip, type: String

  property :start, type: Time
  property :end, type: Time

  #Méta-données
  property :video_viewed, type: Integer, default: 0
  property :quiz_answered, type: Integer, default: 0
  property :page_visited, type: Integer, default: 0
  property :forum_visited, type: Integer, default: 0
  property :forum_posted, type: Integer, default: 0

  validates_presence_of :start
  validates_presence_of :end

  has_one :in, :user, type: :user
  has_many :out, :pages, rel_class: :Event
  has_many :out, :quizs, rel_class: :Result
  
  def set_video_views
    self.video_viewed = self.query_as(:s).match('(s)-[:event]->(v:Video)').count('DISTINCT v')
    self.save
  end

  def set_quiz_answers
    self.quiz_answered = self.query_as(:s).match('(s)-[:result]->(q:Quiz)').count(:q)
    self.save
  end

  def set_forum_visits
    self.forum_visited = self.query_as(:s).match('(s)-[e:event]->(:Fil)').where(e:{event_type: 'forum_visit'}).count(:e)
    self.save
  end

  def set_forum_posts
    self.forum_posted = self.query_as(:s).match('(s)-[e:event]->(:Fil)').where(e:{event_type: 'forum_post'}).count(:e)
    self.save
  end

  def set_page_visits
    #à lancer apres forum post et forum visit
    self.page_visited = self.query_as(:s).match('(s)-[e:event]->(:Page)').where(e:{event_type: 'forum_visit'}).count(:e) - self.forum_visited - self.forum_posted
    self.save
  end
end
