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
    line['page'].split('/').last
  end
  return nil
end

#file = File.new('data/20003S02/non_parsed','r')
file = File.new('data/20003S02/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized','r')
nb = 0
parsed = 0
server = 0
errors = 0
start = Time.now
file.each do |l|
    nb += 1
    puts("parsing #{nb}")
	#puts("parsing line #{nb}")
	
	line = JSON.parse(l)
	if line['event_source'] == "server" 
		server += 1
	end
	if line['event_source'] == "browser" 
		user = User.find_by(user_id: line['context']['user_id'])
		if user then
            s = Session.where(name: line['session']).first
		    #s = Session.find_by(name: line['name'], user: user)
            if s and !(s.user_id == line['context']['user_id'])
              errors += 1
            end
			if s.nil?
                s = Session.create({name: line['session'], agent: line['agent']})
				user.sessions << s
				user.save
			end
		else
			user = User.create({username: line['username'], user_id: line['context']['user_id']})
            s = Session.where(name: line['session']).first
		    #s = Session.find_by(name: line['name'], user: user)
            if s and !(s.user_id == line['context']['user_id'])
              errors += 1
            end
			if s.nil?
                s = Session.create({name: line['session'], agent: line['agent']})
				user.sessions << s
				user.save
			end
		end
        page = Page.find_by(myid: get_id(line))
          
        if nb == 49685
          puts(l)
          puts(page.display_name)
          puts(s.agent)
        end
          
        
		if page
			time = DateTime.iso8601(line['time'])
            rel = Event.create(from_node: s, to_node: page, time: time, event_type: "browser", org_id: line['context']['org_id'], path: line['context']['path'], event_id: line['event']['id'])
		end
		parsed += 1
		puts("parsed : #{parsed}, line : #{nb}")
	end
end
duration = Time.now - start
puts("duration : #{duration}")
puts("server : #{server}")
  puts("erreurs : #{errors}")
  

		
