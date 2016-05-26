module Regroup
  module Users
    #sert à regrouper les users selon des critères quantitatifs, 
    #minimum, maximum ou fourchette de valeurs (on utilisera -1 pour annuler une borne
    #on peut préciser une semaine, sinon ce sera sur la globalité du cours
    
    
    def forum_participation(min, max, week = nil)
      #critère de création de threads/responses/comments sur le forum
      
    end
    
    def forum_consultation(min, max, week = nil)
      #critère de consultation de threads sur le forum
    end
    
    def video_watching(min, max, week = nil)
      #critère de visionnage de vidéos
      if max == -1
        # plus de
        return User.as(:u).match_nodes(w: week).match('(u)-[i:info_week]->(w)').where("i.video_viewed >= #{min}").count(:u)
      elsif min == -1
        # moins de
        return User.as(:u).match_nodes(w: week).match('(u)-[i:info_week]->(w)').where("s.video_viewed <= #{max}").count(:u)
      else
        # range
        return User.as(:u).match_nodes(w: week).match('(u)-[i:info_week]->(w)').where(s: {video_viewed: (min..max)}).count(:u)
      end
    end
    
    def quiz_answering(min, max, week = nil)
      #critère de réponse à des quiz
      if max == -1
        # plus de
        return User.as(:u).match_nodes(w: week).match('(u)-[i:info_week]->(w)').where("i.video_viewed >= #{min}").count(:u)
      elsif min == -1
        # moins de
        return User.as(:u).match_nodes(w: week).match('(u)-[i:info_week]->(w)').where("s.video_viewed <= #{max}").count(:u)
      else
        # range
        return User.as(:u).match_nodes(w: week).match('(u)-[i:info_week]->(w)').where(s: {video_viewed: (min..max)}).count(:u)
      end
    end
    
    def global_activity(min, max, week = nil)
      #critère d'activité par semaine 
      #À DÉFINIR
    end
    
  end
end