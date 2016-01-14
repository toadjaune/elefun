#!/usr/bin/env ruby
require 'json'

#file = File.new('data/course_head.json','r')
file1 = File.new('data/20003S02/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized','r')
file2 = File.new('data/20003S02/browser_events','w')

i = 0
file1.each do |l|
	line = JSON.parse(l)
	if line['event_source'] == "browser" 
		file2.write(l)
		i += 1
	end
end
puts("#{i} browser events")

#ce script sert à obtenir les events de type browser qui nous intéressent dans un nouveau fichier