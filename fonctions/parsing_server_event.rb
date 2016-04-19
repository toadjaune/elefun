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

#file = File.new('data/20003S02/course_head.json','r')
#file = File.new('data/20003S02/browser_events','r')
#file = File.new('data/20003S02/bug','r')
file = File.new('data/20003S02/export_course_ENSCachan_20003S02_Trimestre_1_2015.log_anonymized','r')
nb = 0
parsed = 0
server = 0
forums = 0
browser = 0
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

    forum = /edx\.forum\.(?<type>.*)\.created/.match(line['event_type'])
    if forum != nil
      forums += 1
      parsed += case forum[:type]
      when 'thread'
        puts('fil')
        f = Fil.new
        f.set(line)
        f.save
        puts(line['event']['id'])
        1
      when 'response'
        puts('response')
        r = Response.new
        r.set(line)
        r.save
        puts(line['event']['id'])
        puts('fil_id : ' + line['event']['discussion']['id'])
        1
      when 'comment'
        puts('comment')
        c = Comment.new
        c.set(line)
        c.save
        puts(line['event']['id'])
        puts('response_id : ' + line['event']['response']['id'])
        1
      else
        puts("What is this ? #{forum[:type]}")
        puts(line)
      end
    end
  elsif line['event_source'] == "browser" and !(line['event_type'] == "page_close")
      browser += 1
  end
end
puts(sess.uniq)
duration = Time.now - start
puts("duration : #{duration}")
puts("server : #{server}")
puts("- forum : #{forums}")
puts("browser : #{browser}")
puts("errors : #{errors}")
puts("sessions trouvées : #{sessions}")
puts("sessions créés : #{new_sessions}")
puts("user créés : #{users}")
puts("relations créées : #{rela}")


db.close()
