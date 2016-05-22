#!/usr/bin/env ruby

require_relative 'common'

file2 = File.new('data/20003S02/browser_events','w')

i = 0
$fichier_log.each do |l|
	line = JSON.parse(l)
  if line['event_source'] == "browser" and !(line['event_type'] == "page_close")
		file2.write(l)
		i += 1
	end
end
puts("#{i} browser events")

#ce script sert à obtenir les events de type browser qui nous intéressent dans un nouveau fichier
