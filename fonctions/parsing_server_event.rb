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

file = File.new('data/20003S02/course_head.json','r')
#file = File.new('data/20003S02/browser_events','r')
#file = File.new('data/20003S02/bug','r')
nb = 0
parsed = 0
server = 0
forum = 0
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
      forum += 1
      parse += case forum[:type]
      when 'fil'
        puts('fil')
        Fil.new.set(line)
        1
      when 'comment'
        puts('comment')
        Comment.new.set(line)
        1
      when 'response'
        puts('response')
        Response.new.set(line)
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
puts("- forum : #{forum}")
puts("browser : #{browser}")
puts("errors : #{errors}")
puts("sessions trouvées : #{sessions}")
puts("sessions créés : #{new_sessions}")
puts("user créés : #{users}")
puts("relations créées : #{rela}")


db.close()
