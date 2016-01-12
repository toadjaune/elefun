#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require_relative 'events'
require_relative 'user'
require_relative 'session'
require_relative 'page'

db = Neo4j::Session.open(:server_db)


file = File.new('../data/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized','r')
file.each do |line|
	a = JSON.parse(line)
	u = User.find_by(user_id: "#{a['context']['user_id']}")
	if !u.empty? then
		s = Session.find_by(name: "#{a['name']}",user: "#{u}"} then
		if !s.empty? && a['event']="browser"
			p = Page.find_by(id: "#{a['event']['id']}")
			if !p.empty?
				rel = Event.new(from_node: "#{s}",to_class: "#{p}",time: "#{a['time']}",event_type: "browser",org_id: "#{a['context']['org_id']}",path: "#{a['context']['path'],}",event_id: "#{a['event']['id']}")
			end

		else




		end
	else
		u = User.create({"username"=>"#{a['username']}", "user_id"=>"#{a['context']['user_id']}"})
		s = Session.create({"name"=>"#{a['name']}","agent"=>"#{a['agent']}","user"=>"#{u}"}) 
	end
end
		
