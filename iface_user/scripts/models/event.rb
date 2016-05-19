require 'neo4j'
require 'date'

class Event < Etiquetable
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
  
  
  def update_user_stats
    case self.time <=> from_class.date_debut
      when -1
        from_class.date_debut = self.time
      when 1
        from_class.date_fin=self.time unless ( from_class.date_fin <=> self.time ) != -1 
    end
    i = from_class.user.info(:i).where('t.week.date_debut < {date} and t.week.date_fin >= {date}').params(date: "#{self.time}").pluck(:i)
    i.activite = (from_class.date_fin.to_time-from_class.date_fin.to_time+3600).to_datetime
    case to_class.labels[1].to_s    
      when ""
        i.page_visitees+=1
      when "Fil"
        i.forum_lu+=1
        to_class.add_views
      when "Video"
        i.video_play+=1
        to_class.add_views
      when "Quizz"
        i.quizz+=1
        to_class.add_part     
    end
  end
end
