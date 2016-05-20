#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require 'date'

require_relative 'models/event'
require_relative 'models/user'
require_relative 'models/session'
require_relative 'models/page'
require_relative 'models/fil'
require_relative 'models/response'
require_relative 'models/comment'

require_relative 'models/quiz'
require_relative 'models/question'
require_relative 'models/result'

require_relative 'parsers/problem'
require_relative 'parsers/user_session'
require_relative 'parsers/enrollment'
require_relative 'parsers/forum'
require_relative 'parsers/browser'

db = Neo4j::Session.open(:server_db)


# Quelques données propres à ce MOOC
$auteur = 'ENSCachan'
$id_cours = '20003S02'
$periode = 'Trimestre_1_2015'

def parse_logs(filename)
  file = File.new(filename,'r')
  $toparse = File.new('data/20003S02/left_to_parse','w')
  $bugged = File.new('data/20003S02/bugged','w')
  $nb = 0
  $parsed = 0
  $new_users = 0
  $new_users_enroll = 0
  $session_time_out = 0
  $new_sessions = 0
  $new_relations = 0
  $page_errors = 0
  $session_errors = 0
  $parsed_questions = 0
  start = Time.now
  $sess = []

  $server = 0
  $browser = 0

  $errors = 0

  file.each do |l|
    $nb += 1
    line = JSON.parse(l)
    begin
      ### GET SESSION

      ### SERVER_EVENTS
      if line['event_source'] == "server"
        $server += 1
        case line['event_type']
          when 'problem_check'
            user = Parser.get_user(line)
            Parser.problem_check_parser(line, user) ? $parsed += 1 : $toparse.write(l)
          when /edx\.forum\.(?<type>.*)\.created/
            Parser.created_forum_parser(line, $LAST_MATCH_INFO['type']) ? $parsed += 1 : $toparse.write(l)
          when /\/courses\/#{$auteur}\/#{$id_cours}\/#{$periode}\/discussion\/(?<type>.+)/
            discussion = /(?<categorie>[^\/]*)\/(?<arg>.*)/.match($LAST_MATCH_INFO['type'])
            #hack dégueulasse sur la ligne suivante
            if discussion
              Parser.discussion_forum_parser(line, discussion) ? $parsed += 1 : $toparse.write(l)
            end
          when '/create_account'
            #puts('Enroll')
            Parser.enrollment_parser(line) ? $parsed += 1 : $toparse.write(l)
          else
            $toparse.write(l)
        end

      ### BROWSER_EVENTS
      elsif line['event_source'] == "browser" and !(line['event_type'] == "page_close") and !line['session'].blank?
        user,session = Parser.get_session(line)
        $browser += 1
        Parser.browser_parser(line, user, session) ? $parsed += 1 : $toparse.write(l)
      end
      if $nb % 100 == 0
        puts($nb)
      end
    rescue Exception => e
      $errors+=1
      if $errors > 10
        abort
      end
      puts e.message
      puts e.backtrace
      $bugged.write e.message
      $bugged.write e.backtrace
      $bugged.write("#{$nb}:"+l)
    end
  end
  duration = Time.now - start
  puts("durée (en min) : #{duration/60}")
  puts("total : #{$nb}")
  puts("parsed : #{$parsed}")
  puts("server : #{$server}")
  puts("browser : #{$browser}")
  puts("sessions appartenant à plus d'un user : #{$session_errors}")
  puts("pages non trouvées : #{$page_errors}")
  puts("sessions créés : #{$new_sessions}")
  puts("session timed out : #{$session_time_out}")
  puts("user créés via enrollment : #{$new_users_enroll}")
  puts("user créés via browser : #{$new_users}")
  puts("questions traitées : #{$parsed_questions}")
  puts("relations créées : #{$new_relations}")
  
  result = File.new('results', 'a')
  result.puts("#{Time.now}")
  result.puts("durée (en min) : #{duration/60}")
  result.puts("total : #{$nb}")
  result.puts("parsed : #{$parsed}")
  result.puts("server : #{$server}")
  result.puts("browser : #{$browser}")
  result.puts("sessions appartenant à plus d'un user : #{$session_errors}")
  result.puts("pages non trouvées : #{$page_errors}")
  result.puts("sessions créés : #{$new_sessions}")
  result.puts("session timed out : #{$session_time_out}")
  result.puts("user créés via enrollment : #{$new_users_enroll}")
  result.puts("user créés via browser : #{$new_users}")
  result.puts("questions traitées : #{$parsed_questions}")
  result.puts("relations créées : #{$new_relations}")
  result.puts("_________________________________")
end

#parse_logs('data/20003S02/course_head.json')
parse_logs('prout')
#parse_logs('data/20003S02/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized')
