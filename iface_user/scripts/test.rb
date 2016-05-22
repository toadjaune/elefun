#!/usr/bin/env ruby

#fichier bac à sable pour tester tout et rien

#on compte ce qu'on arrive à parser parmi les events browser en première partie en parsant sur le :path puis sur le event[:id]

#question = Quiz.find_by(myid: "8367920c39f34e06bd5c64394f3a11d8")



file = File.new('data/20003S02/browser_events','r')

#file2 = File.new('data/20005S03/event_types', 'w')

h= Hash.new(0)

file.each do |line|
  l = JSON.parse(line.match('{.*}$')[0])
  h[l['event_type']] += 1
end

h.each do |event, nb|
  puts("#{event} | #{nb}")
end
