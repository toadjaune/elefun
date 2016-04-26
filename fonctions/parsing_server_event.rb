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

auteur = 'ENSCachan'
id_cours = '20003S02'
periode = 'Trimestre_1_2015'

file.each do |l|
  nb += 1
  #puts("parsing line #{nb}")

  line = JSON.parse(l)

  if line['event_source'] == "server" 
    server += 1

    forum = /edx\.forum\.(?<type>.*)\.created/.match(line['event_type'])
    forum2 = /\/courses\/#{auteur}\/#{id_cours}\/#{periode}\/discussion\/(?<type>.*)/.match(line['event_type'])
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
        puts("What is this? #{forum[:type]}")
        puts(line)
      end
    elsif forum2 != nil
      forum2b = /(?<categorie>[^\/]*)\/(?<arg>.*)/.match(forum2[:type])
      parsed += case forum2[:categorie]
                when /((\h{15,})|(i4x-#{auteur}-#{id_cours}-course-#{periode}_(?<partie>\w*)))/
                  if /threads\/create/.match(forum2[:arg]) != nil
                    puts('fil /discussion')
                    f = Fil.new
                    f.set_discuss(line)
                    f.save
                    1
                  else
                    puts("What is this hexa discussion? #{forum2[:categorie]}")
                    puts(line)
                  end
                when 'threads', 'comments'
                  action = /(?<id_fil>\h*)\/(?<action>.*)/.match(forum2[:arg])
                  case action[:action]
                  when 'update'
                    puts("fil /discussion : #{forum2[:categorie]} update")
                    f = (forum2[:categorie] == 'thread' ? Fil.find_by(myid: action[:id_fil]) : Response.find_by(myid: action[:id_fil]))
                    if !f
                      puts("#{forum2[:categorie]} inconnu jusque là ; id :#{action[:id_fil]}")
                      f = (forum2[:categorie] == 'thread' ? Fil.New : Response.New)
                      f[:myid] = action[:id_fil]
                    end
                    f.set_discuss(line)
                    f.save
                    1
                  when 'delete'
                    puts("fil /discussion : #{forum2[:categorie]} delete (id: #{action[:id_fil]}")
                    f = (forum2[:categorie] == 'thread' ? Fil.find_by(myid: action[:id_fil]) : Response.find_by(myid: action[:id_fil]))
                    if f
                      f.delete
                      f.save
                    end
                    1
                  when 'reply'
                    puts("fil /discussion : #{forum2[:categorie]} reply (id: #{action[:id_fil]}")
                    f = (forum2[:categorie] == 'thread' ? Fil.find_by(myid: action[:id_fil]) : Response.find_by(myid: action[:id_fil]))
                    if !f
                      puts("#{forum2[:categorie]} inconnu jusque là ; id :#{action[:id_fil]}")
                      f = (forum2[:categorie] == 'thread' ? Fil.New : Response.New)
                      f[:myid] = action[:id_fil]
                    end
                    r = (forum2[:categorie] == 'thread' ? Reponse.New : Comment.New)
                    r.set_discuss(line, f)
                    r.save
                    1
                  when 'pin'
                    puts("#{forum2[:categorie]} /discussion : pin mystère...")
                    # A voir quel usage ça a et à quoi ça correspond
                    1
                  when 'follow'
                    puts("#{forum2[:categorie]} /discussion : follow")
                    # idem, voir si on en a utilité
                    1
                  when 'unfollow'
                    puts("#{forum2[:categorie]} /discussion : unfollow")
                    #idem
                    1
                  when 'upvote'
                    puts("#{forum2[:categorie]} /discussion : upvote")
                    #idem
                    1
                  when 'unvote'
                    puts("#{forum2[:categorie]} /discussion : unvote")
                    #idem
                    1
                  when 'close'
                    puts("#{forum2[:categorie]} /discussion : close")
                    #...
                    1
                  when 'flagAbuse'
                    puts("#{forum2[:categorie]} /discussion : flagAbuse")
                    #...
                    1
                  when 'endorse'
                    puts("#{forum2[:categorie]} /discussion : endorse")
                    #...
                    1
                  else
                    puts("What is this discussion/thread ? #{action[:action]}")
                    puts(line)
                  end
                when 'upload'
                  puts('discussion/upload')
                  1
                when 'users'
                  puts('discussion/users')
                  1
                when 'forum'
                  case forum2[:arg]
                  when ''
                    puts('discussion/forum')
                    1
                  when 'search'
                    puts('discussion/forum/search')
                    1
                  else
                    frm = /(?<id_conv>\h{10,})\/(?<element>\w*)(\z|(\/(?<id_thread>\h{10,})))/.match(forum2[:arg])
                    case frm[:element]
                    when 'inline'
                      puts("discussion/forum/.../inline")
                      1
                    when 'threads'
                      puts("/discussion/forum/.../threads/...")
                      1
                    else
                      puts("Element de discussion/forum inconnu")
                      puts(line)
                    end
                  end
                else
                    puts("What is this discussion? #{forum2[:categorie]}")
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
