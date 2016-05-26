module Regroup
  module Sessions
    #sert à regrouper les sessions selon des critères quantitatifs, 
    #minimum, maximum ou fourchette de valeurs (on utilisera -1 pour ne pas prendre en compte une borne
    # convention : [min,max] (on inclut les bornes)
    
    def self.forum_participation(min, max)
      #critère de création de threads/responses/comments sur le forum
      if min == -1
        # plus de
        return Session.as(:s).where("s.forum_posted >= #{min}").count
      elsif max == -1
        # moins de
        return Session.as(:s).where("s.forum_posted <= #{max}").count
      else
        # range
        return  Session.as(:s).where(s: {forum_posted: (min..max)}).count
      end
    end
    
    def self.forum_consultation(min, max)
      #critère de consultation de threads sur le forum
      if min == -1
        # plus de
        return Session.as(:s).where("s.forum_visited >= #{min}").count
      elsif max == -1
        # moins de
        return Session.as(:s).where("s.forum_visited <= #{max}").count
      else
        # range
        return  Session.as(:s).where(s: {forum_visited: (min..max)}).count
      end
    end
    
    def self.video_watching(min, max)
      #critère de visionnage de vidéos
      if min == -1
        # plus de
        return Session.as(:s).where("s.video_viewed >= #{min}").count
      elsif max == -1
        # moins de
        return Session.as(:s).where("s.video_viewed <= #{max}").count
      else
        # range
        return  Session.as(:s).where(s: {video_viewed: (min..max)}).count
      end
    end
    
    def self.quiz_answering(min, max)
      #critère de réponse à des quiz
      if min == -1
        # plus de
        return Session.as(:s).where("s.quiz_answered >= #{min}").count
      elsif max == -1
        # moins de
        return Session.as(:s).where("s.quiz_answered <= #{max}").count
      else
        # range
        return  Session.as(:s).where(s: {quiz_answered: (min..max)}).count
      end
    end
    
    def self.global_activity(min, max)
      #À DÉFINIR
    end
  end
end