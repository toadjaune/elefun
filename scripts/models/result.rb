class Result
  #regroupe les résultats au quiz d'un user via une de ses session 
  include Neo4j::ActiveRel
  
  from_class :Session
  to_class :Quiz
  type 'result'
  
  type 'result'
  property :grade, type: Integer, default: 0
  property :max_grade, type: Integer, default: 0
  property :attempts, type: Integer, default: 0
  
  def update_result(event)
    self.grade += event['grade']
    self.max_grade += event['max_grade']
    self.attempts += event['attempts']
    self.save
  end
end
