#!/usr/bin/env ruby
module Parser 
  def self.problem_check_parser(line)
    user, session = Parser.get_session(line)
    
    problem_id = line['event']['problem_id'].split("/").last
    
    #query a test
    quiz = Quiz.query_as(:q).match('(q)-->(p:Page)').where(p: {myid: problem_id}).pluck(:q).first
    
    time = DateTime.iso8601(line['time'])
    
    Event.create(from_node: session, to_node: quiz, time: time, event_type: line['event_type'], event_source: line['event_source'])
    $new_relations += 1
    
    r = session.query_as(:s).match_nodes(q: quiz).match('(s)-[r:result]->(q)').pluck(:r)
    if r.empty?
      result = Result.create(from_node: session, to_node: quiz)
    elsif r.length > 1
      puts "MORE THAN 1 RESULT"
      return false
    else
      result = r.first
    end
    $parsed_questions += 1    
    result.update_result(line['event'])
    return true
  end
end
    
    
  