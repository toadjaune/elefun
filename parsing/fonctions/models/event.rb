require 'neo4j'
require 'date'

class Event
  #Représente les différents event liant Page et User via des Sessions
  include Neo4j::ActiveRel
  
  from_class :Session
  to_class :Page
  type 'event'
  
  property :event_type, type: String
  property :time, type: DateTime
  
  after_create :update_user_stats
  #context
  property :org_id, type: String
  property :path, type: String
  
  #event
  property :event_id, type: String
  property :event_POST, type: String
  property :event_GET, type: String
  
  property :page, type: String
  
  property :event_source, type: String
  
    :time
  
  def update_user_stats
    case self.time <=> from_class.date_debut
      when -1
        from_class.date_debut = self.time
      when 1
        from_class.date_fin=self.time unless ( from_class.date_fin <=> self.time ) != -1 
    end
    i = from_class.user.info(:i).where('t.week.date_debut < {date} and t.week.date_fin >= {date}').params(date: "#{self.time}").pluck(:i)
    i.activite = (from_class.date_fin.to_time-from_class.date_fin.to_time+3600).to_datetime
    #case to_class.labels
    #  when "[:Cours]"
    #    from_class.page_visitees++
    #  when "[:Comment]"
    #    from_class.forum_msg++
    #  when "[:Video]"
    #    from_class.video_play++
    #  when "[:Quizz]"
    
  
end