#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require 'date'

require_relative 'models/event'
require_relative 'models/user'
require_relative 'models/session'
require_relative 'models/page'
require_relative 'models/video'
require_relative 'models/fil'
require_relative 'models/response'
require_relative 'models/comment'
require_relative 'models/question'
require_relative 'models/result'
require_relative 'models/quiz'

db = Neo4j::Session.open(:server_db)

#fichier bac à sable pour tester tout et rien

#on compte ce qu'on arrive à parser parmi les events browser en première partie en parsant sur le :path puis sur le event[:id]

#question = Quiz.find_by(myid: "8367920c39f34e06bd5c64394f3a11d8")
line = JSON.parse('{"event_type": "problem_check", "agent": "Mozilla/5.0 (Windows NT 6.1; rv:37.0) Gecko/20100101 Firefox/37.0", "page": "x_module", "accept_language": "fr;q=1.0, fr-FR;q=0.8, en-US;q=0.5, en;q=0.3", "referer": "https://www.france-universite-numerique-mooc.fr/courses/ENSCachan/20003S02/Trimestre_1_2015/courseware/427ab1f6b6224569ae7b1deb543a77ea/82d3fcfbc83548318c543a98cec4f055/", "username": "7a27de6b1b81420872f26cac4f0329f51a93a2c16be2cfa277d53d147423e5ca", "time": "2015-04-09T17:40:20.054154+00:00", "context": {"module": {"usage_key": "i4x://ENSCachan/20003S02/problem/f34b8552589841fc98e8089be87856f3", "display_name": "Question 5 "}, "user_id": 179553, "path": "/courses/ENSCachan/20003S02/Trimestre_1_2015/xblock/i4x:;_;_ENSCachan;_20003S02;_problem;_f34b8552589841fc98e8089be87856f3/handler/xmodule_handler/problem_check", "org_id": "ENSCachan", "course_user_tags": {}, "course_id": "ENSCachan/20003S02/Trimestre_1_2015"}, "ip": "", "event": {"submission": {"i4x-ENSCachan-20003S02-problem-f34b8552589841fc98e8089be87856f3_2_1": {"response_type": "optionresponse", "input_type": "optioninput", "answer": "communaut\u00e9 de co\u00e9laboration de connaissances", "variant": "", "correct": false, "question": "Quel qualificatif (un sigle ou plusieurs mots) d\u00e9signe une communaut\u00e9 construisant un discours collectif progressif dans une classe ?"}}, "state": {"correct_map": {}, "input_state": {"i4x-ENSCachan-20003S02-problem-f34b8552589841fc98e8089be87856f3_2_1": {}}, "student_answers": {"i4x-ENSCachan-20003S02-problem-f34b8552589841fc98e8089be87856f3_2_1": "communaut\u00e9 de co\u00e9laboration de connaissances"}, "seed": 1, "done": false}, "answers": {"i4x-ENSCachan-20003S02-problem-f34b8552589841fc98e8089be87856f3_2_1": "communaut\u00e9 de co\u00e9laboration de connaissances"}, "success": "incorrect", "grade": 0, "correct_map": {"i4x-ENSCachan-20003S02-problem-f34b8552589841fc98e8089be87856f3_2_1": {"queuestate": null, "answervariable": null, "npoints": null, "msg": "", "correctness": "incorrect", "hint": "", "hintmode": null}}, "problem_id": "i4x://ENSCachan/20003S02/problem/f34b8552589841fc98e8089be87856f3", "attempts": 1, "max_grade": 1}, "host": "www.france-universite-numerique-mooc.fr", "event_source": "server"}')

problem_id = line['event']['problem_id'].split("/").last
puts problem_id
quiz = Quiz.query_as(:q).match('q-->(p:Page)').where("p.myid=\"#{problem_id}\"").pluck(:q).first
puts quiz

require_relative 'parsers/user_session'
user = Parser.get_user(line)
puts user
time = DateTime.iso8601(line['time'])
r = user.query_as(:u).match_nodes(q: quiz).match('u-[r:result]->q').pluck(:r)
if r.empty?
  result = Result.create(from_node: user, to_node: quiz)
elsif r.length > 1
  puts "MORE THAN 1 RESULT"
else
  result = r.first
end
file1 = File.new('data/20003S02/quiz','r')
file2 = File.new('event_type_spreadsheet','w')
#file = File.new('data/20003S02/enrollments','r')
nb = 0
correct = 0
grade = 0
a=0
b=0

