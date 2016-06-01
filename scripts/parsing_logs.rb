#!/usr/bin/env ruby

require_relative 'common'

def parse_logs(filename)
  file = File.new(filename,'r')
  $toparse = File.new('fichiers/20003S02/left_to_parse','w')
  $bugged = File.new('fichiers/20003S02/bugged','w')
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
  
  $inactivite = 3600
  
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
      case line['event_type']
        when 'problem_check'
          if line['event_source'] == "server"
            Parser.problem_check_parser(line) ? $parsed += 1 : $toparse.write(l)
          end
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
      when /courseware\/(?<page_1>\h{10,32})(\z|(\/(?<page_2>\h{10,32})))/
          id = $LAST_MATCH_INFO['page_2'] ? $LAST_MATCH_INFO['page_2'] : $LAST_MATCH_INFO['page_1']
        type = "page_visit"
        Parser.browser_parser(line, id, type) ? $parsed += 1 : $toparse.write(l)
        when 'play_video'
          id = line['event']['id'].split('-').last
          type = "play_video"
        Parser.browser_parser(line, id, type) ? $parsed += 1 : $toparse.write(l)
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

parse_logs('data/20003S02/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized')
