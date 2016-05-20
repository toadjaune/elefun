require 'neo4j'
require 'date'


require_relative '../regroup/session'

class Session
  #Appartient à un User et regroupe un ensemble de Page visitées
  include Regroup::Sessions

  #Donées
  property :name, type: String, constraint: :unique
  property :agent, type: String
  property :ip, type: String

  property :start, type: DateTime
  property :end, type: DateTime

  #Méta-données
  property :page_vues, type: Integer, default: 0
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

  def add_views
    self.video_viewed +=1
    self.save
  end

  def set_quiz
    self.quiz_answered = self.query_as(:s).match('s-[:event]->(:Question)<--(q:Quiz)').count('DISTINCT q')
    self.save
  end

  def add_quiz
    self.quiz_answered +=1
    self.save
  end

  def set_visit
    self.forum_visited = self.query_as(:s).match('s-[e:event]->(:Fil)').where(e:{event_type: 'forum_visit'}).count(:e)
    self.save
  end

  def add_visit
    self.page_vues+=1
    self.save
  end

  def set_posts
    self.forum_posted = self.query_as(:s).match('s-[e:event]->(:Fil)').where(e:{event_type: 'forum_post'}).count(:e)
    self.save
  end

  def add_posts
    self.forum_posted+=1
    self.save
  end

  def add_forum_visits
    self.forum_visited+=1
    self.save
  end

  def end_inactivity
    self.name += rand(36**10).to_s(36)
    self.save
  end
end