#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require 'date'

require_relative 'models/event'
require_relative 'models/user'
require_relative 'models/session'
require_relative 'models/page'

db = Neo4j::Session.open(:server_db)


#file = File.new('data/course_head.json','r')
file = File.new('data/20003S02/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized','r')
nb = 1
parsed = 0
server = 0
start = Time.now
file.each do |l|
	#puts("parsing line #{nb}")
	
	line = JSON.parse(l)
	if line['event_source'] == "server" 
		server += 1
	end
	if line['event_source'] == "browser" 
		user = User.find_by(user_id: line['context']['user_id'])
		if user then
			s = user.sessions.where(name: line['name'])
			#s = Session.find_by(name: line['name'], user: user)
			if s.nil?
				s = Session.create({name: line['name'], agent: line['agent']})
				user.sessions << s
				user.save
			end
		else
			user = User.create({username: line['username'], user_id: line['context']['user_id']})
			s = Session.create({name: line['name'], agent: line['agent']}) 
			user.sessions << s
			user.save
		end
		page = Page.find_by(id: line['event']['id'])
		if page
			time = DateTime.iso8601(line['time'])
			rel = Event.create(from_node: s,to_class: page,time: time,event_type: "browser",org_id: line['context']['org_id'],path: a['context']['path'],event_id: line['event']['id'])
		end
		parsed += 1
		puts("parsed : #{parsed}, line : #{nb}")
	end
	nb += 1
end
duration = Time.now - start
puts("duration : #{duration}")
puts("server : #{server}")
		
