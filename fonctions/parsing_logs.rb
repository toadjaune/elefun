#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require_relative 'event'
require_relative 'user'
require_relative 'session'
require_relative 'page'

db = Neo4j::Session.open(:server_db)


file = File.new('data/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized','r')
file.each do |l|
    line = JSON.parse(l)
    user = User.find_by(user_id: line['context']['user_id'])
	if !user.empty? then
		s = user.sessions.where(name: line['name']).first
		#s = Session.find_by(name: line['name'], user: user)
		if s.empty? 
			s = Session.create({name: line['name'], agent: line['agent'], user: u}) 
		end
	else
		user = User.create({username: line['username'], user_id: line['context']['user_id']})
		s = Session.create({name: line['name'], agent: line['agent'], user: u}) 
	end
		
	if line['event'] == "browser"
		page = Page.find_by(id: line['event']['id'])
		if !page.empty?
			time = Datetime.iso8601(line['time'])
			rel = Event.new(from_node: s,to_class: page,time: time,event_type: "browser",org_id: line['context']['org_id'],path: a['context']['path'],event_id: line['event']['id'])
end
		
