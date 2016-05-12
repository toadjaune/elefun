#!/usr/bin/env ruby
module Parser 
  def self.problem_check_parser(line, user)
    problem_id = line['event']['problem_id'].split("/").last
    quiz = Quiz.query_as(:q).match('q-->(p:Page)').where("p.myid=\"#{problem_id}\"").pluck(:q).first
    time = DateTime.iso8601(line['time'])
    r = user.query_as(:u).match_nodes(q: quiz).match('u-[r:result]->q').pluck(:r)
    if r.empty?
      result = Result.create(from_node: user, to_node: quiz)
    elsif r.length > 1
      puts "MORE THAN 1 RESULT"
    else
      result = r.first
    end
    $parsed_questions += 1    
    result.update_result(line['event'])
    return true
  end
end
    
    
  