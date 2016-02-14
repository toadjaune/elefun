#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require 'date'

require_relative 'models/event'
require_relative 'models/user'
require_relative 'models/session'
require_relative 'models/page'

db = Neo4j::Session.open(:server_db)

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

#file = File.new('data/20003S02/course_head.json','r')
file = File.new('data/20003S02/browser_events','r')
#file = File.new('data/20003S02/bug','r')
nb = 0
parsed = 0
server = 0
users = 0
sessions = 0
new_sessions = 0
errors = 0
rela = 0
start = Time.now
sess = []
file.each do |l|
    nb += 1
	#puts("parsing line #{nb}")
	
	line = JSON.parse(l)
  
	if line['event_source'] == "server" 
		server += 1
	elsif line['event_source'] == "browser" and !(line['event_type'] == "page_close")
		user = User.find_by(user_id: line['context']['user_id'])
		
		if user then
            s = user.sessions.as(:s).where(name: line['session']).pluck(:s).first
		    if s.nil?
                s = Session.create({name: line['session'], agent: line['agent']})
                new_sessions += 1
                user.sessions << s
				user.save
			else
				sessions += 1
		    end
		
		
		else
		    user = User.create({username: line['username'], user_id: line['context']['user_id']})
            users += 1
			s = Session.as(:s).where(name: line['session']).pluck(:s).first
			if s.nil?
				s = Session.create(name: line['session'], agent: line['agent'])
                new_sessions += 1
			else
				sessions += 1
			end
			user.sessions << s
			user.save
		end
		page = Page.find_by(myid: get_id(line))
		if page.nil?
			puts("error #{line['event_type']}")
			errors += 1
		end
        if nb == 101204
			puts(line)
		end
        
      if page and !s.name.empty?
			time = DateTime.iso8601(line['time'])
            rel = Event.create(from_node: s, to_node: page, time: time, event_type: "browser", org_id: line['context']['org_id'], path: line['context']['path'], page: line['page'])
			rela += 1
		end
		parsed += 1
		puts("parsed : #{parsed}, line : #{nb}")
	end
end
puts(sess.uniq)
duration = Time.now - start
puts("duration : #{duration}")
puts("server : #{server}")
puts("errors : #{errors}")
puts("sessions trouvées : #{sessions}")
puts("sessions créés : #{new_sessions}")
puts("user créés : #{users}")
puts("relations créées : #{rela}")
  

		
