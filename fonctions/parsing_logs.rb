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

db = Neo4j::Session.open(:server_db)


#renvoit l'id de la page suivant les différents format possible
def get_id(line)
  if line['event'].is_a?(Hash) and id = line['event']['id']
    if id.match '^i4x:'
      return id.split('/').last
    else
      return id.split('-').last
    end
  else
	return line['page'].split('/').last
  end
  return nil
end

def parse_logs(filename)
  file = File.new(filename,'r')
  toparse = File.new('data/20003S02/left_to_parse','w')
  nb = 0
  parsed = 0
  new_users = 0
  new_sessions = 0
  new_relations = 0
  page_errors = 0
  session_errors = 0
  start = Time.now
  sess = []
  
  server = 0
  forums = 0
  browser = 0
  

  file.each do |l|
    nb += 1
    line = JSON.parse(l)

    if line['event_source'] == "server" 
      server += 1
      case line['event_type']
        when '/create_account'
          #puts('Enroll')
          if !line['event']['POST'].nil?   
            u = User.find_by(username: line['event']['POST']['username'])
            if u.nil?
              u = User.new
              u.set(line['event']['POST'])
              u.save
              new_users += 1
            end
          end
          parsed += 1
        when 'edx.forum.thread.created'
          puts('fil')
          f = Fil.new
          f.set(line)
          f.save
          #puts(line['event']['id'])
          parsed += 1
        when 'edx.forum.response.created'
          puts('response')
          r = Response.new
          r.set(line)
          r.save
          #puts(line['event']['id'])
          #puts('fil_id : ' + line['event']['discussion']['id'])
          parsed += 1
        when 'edx.forum.comment.created'
          puts('comment')
          c = Comment.new
          c.set(line)
          c.save
          #puts(line['event']['id'])
          #puts('response_id : ' + line['event']['response']['id'])
          parsed += 1
        else
          toparse.write(l+'\n')
          puts('prout')
          puts(line)
      end
    elsif line['event_source'] == "browser" and !(line['event_type'] == "page_close") and !line['session'].blank?
      browser += 1
    
      ###GET SESSIONS
      #on cherche si on connait le user
      user = User.find_by(user_id: line['context']['user_id'])
      if user then
        #si oui, on cherche si l'on connait déjà la session actuelle
        s = user.sessions.as(:s).where(name: line['session']).pluck(:s).first
        if s.nil?
          #sinon on la crée
          s = Session.create({name: line['session'], agent: line['agent']})
          new_sessions += 1
          user.sessions << s
          user.save
        end
      else
        #on crée le user s'il n'existe pas déjà
        user = User.create({username: line['username'], user_id: line['context']['user_id']})
        new_users += 1
        s = Session.as(:s).where(name: line['session']).pluck(:s).first
        if s.nil? and !line['session'].empty?
          #cas normal
          s = Session.create(name: line['session'], agent: line['agent'])
          new_sessions += 1
        else
          # la session appartient à plus d'un user ou nom vide
          session_errors += 1
        end
        user.sessions << s
        user.save
      end
      ###

      #on récupère l'id de la page
      page = Page.find_by(myid: get_id(line))
      if page.nil?
        puts("error #{line['event_type']}")
        page_errors += 1
        toparse.write(line+'\n')
      else
        time = DateTime.iso8601(line['time'])
        rel = Event.create(from_node: s, to_node: page, time: time, event_type: line['event_type'], org_id: line['context']['org_id'], path: line['context']['path'], page: line['page'])
        new_relations += 1
      end
    end
    if nb % 20 == 0
      puts(nb)
    end
  end
  duration = Time.now - start
  puts("durée (en min) : #{duration/60}")
  puts("total : #{nb}")
  puts("parsed : #{parsed}")
  puts("server : #{server}")
  puts("browser : #{browser}")
  puts("sessions appartenant à plus d'un user : #{session_errors}")
  puts("pages non trouvées : #{page_errors}")
  puts("sessions créés : #{new_sessions}")
  puts("user créés : #{new_users}")
  puts("relations créées : #{new_relations}")
end

#parse_logs('data/20003S02/course_head.json')
parse_logs('data/20003S02/enrollments')
#parse_logs('data/20003S02/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized')
  

		
