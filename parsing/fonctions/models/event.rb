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
  
  #after_create :update_user_stats
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
    case self.time <=> self.from_node.date_debut
      when -1
        self.from_node.date_debut = self.time
      when 1
        self.from_node.date_fin=self.time unless ( self.from_node.date_fin <=> self.time ) != -1 
    end
    
    #accéder aux infos suivant le model :
    # Student.first.lessons.each_rel { |r| }
    i = self.from_node.user.infos(:i).where('t.week.date_debut < {date} and t.week.date_fin >= {date}').params(date: "#{self.time}").pluck(:i)
    i.activite = (self.from_node.date_fin.to_time-self.from_node.date_fin.to_time+3600).to_datetime
    case self.to_node.labels[1].to_s    
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