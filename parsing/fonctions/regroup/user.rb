module Regroup
  module Users
    #sert à regrouper les users selon des critères quantitatifs, 
    #minimum, maximum ou fourchette de valeurs (on utilisera +-INFINITY en donnant un couple de valeurs
    #on peut préciser une semaine, sinon ce sera sur la globalité du cours
    
    
    def forum_participation(min, max, week = nil)
      #critère de création de threads/responses/comments sur le forum
    end
    
    def forum_consultation(min, max, week = nil)
      #critère de consultation de threads sur le forum
    end
    
    def video_watching(min, max, week = nil)
      #critère de visionnage de vidéos
    end
    
    def quiz_answering(min, max, week = nil)
      #critère de réponse à des quiz
    end
    
    def global_activity(min, max, week = nil)
      #critère d'activité par semaine 
      #À DÉFINIR
    end
    
  end
end