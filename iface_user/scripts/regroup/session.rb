module Regroup
  module Sessions
    #sert à regrouper les sessions selon des critères quantitatifs, 
    #minimum, maximum ou fourchette de valeurs (on utilisera +-INFINITY en donnant un couple de valeurs    
    
    def forum_participation(min, max)
      #critère de création de threads/responses/comments sur le forum
    end
    
    def forum_consultation(min, max)
      #critère de consultation de threads sur le forum
    end
    
    def video_watching(min, max)
      #critère de visionnage de vidéos
    end
    
    def quiz_answering(min, max)
      #critère de réponse à des quiz
    end
    
    def global_activity(min, max)
      #À DÉFINIR
    end
  end
end