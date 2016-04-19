#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require 'date'

require_relative 'models/event'
require_relative 'models/user'
require_relative 'models/session'
require_relative 'models/page'

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
  sessions_errors = 0
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

      forum = /edx\.forum\.(?<type>.*)\.created/.match(line['event_type'])
      if forum != nil
        forums += 1
        parsed += case forum[:type]
        when 'thread'
          puts('fil')
          f = Fil.new
          f.set(line)
          f.save
          #puts(line['event']['id'])
          1
        when 'response'
          puts('response')
          r = Response.new
          r.set(line)
          r.save
          #puts(line['event']['id'])
          #puts('fil_id : ' + line['event']['discussion']['id'])
          1
        when 'comment'
          puts('comment')
          c = Comment.new
          c.set(line)
          c.save
          #puts(line['event']['id'])
          #puts('response_id : ' + line['event']['response']['id'])
          1
        else
          puts("What is this ? #{forum[:type]}")
          #puts(line)
          toparse.write(line)
        end
      else
      toparse.write(line)
      end
    elsif line['event_source'] == "browser" and !(line['event_type'] == "page_close")
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
        toparse.write(line)
      end
      #si on trouve la page
      if page
        time = DateTime.iso8601(line['time'])
        rel = Event.create(from_node: s, to_node: page, time: time, event_type: line['event_type'], org_id: line['context']['org_id'], path: line['context']['path'], page: line['page'])
        new_relations += 1
      end
    end
    if nb % 1000 == 0
      puts(nb)
    end
  end
  duration = Time.now - start
  puts("durée (en min) : #{duration/60}")
  puts("total : #{nb}")
  puts("server : #{server}")
  puts("browser : #{browser}")
  puts("sessions appartenant à plus d'un user : #{session_errors}")
  puts("pages non trouvées : #{page_errors}")
  puts("sessions créés : #{new_sessions}")
  puts("user créés : #{new_users}")
  puts("relations créées : #{new_relations}")
end

#parse_logs('data/20003S02/course_head.json')
#parse_logs('data/20003S02/browser_events')
parse_logs('data/20003S02/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized')
  

		
