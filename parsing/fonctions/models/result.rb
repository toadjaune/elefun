require 'neo4j'
require 'date'

class Result < Event
  
  property :correct, type: Boolean, default: false
  
  def get_result(success, attempts)
    # success = line['event']['success"]
    if success == "correct"
      self.correct = true
    end
    # attempts = line['event']['attempts"]
    self.attempts = attempts
    self.save
end