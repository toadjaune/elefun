#!/usr/bin/env ruby
module Parser
  def self.created_forum_parser(line, type)
    return case type
      when 'thread'
        puts('fil')
        f = Fil.new
        f.set(line)
        f.save
        #puts(line['event']['id'])
        true
      when 'response'
        puts('response')
        r = Response.new
        r.set(line)
        r.save
        #puts(line['event']['id'])
        #puts('fil_id : ' + line['event']['discussion']['id'])
        true
      when 'comment'
        puts('comment')
        c = Comment.new
        c.set(line)
        c.save
        #puts(line['event']['id'])
        #puts('response_id : ' + line['event']['response']['id'])
        true
      else
        #puts("What is this edx.forum type? #{$LAST_MATCH_INFO['type']}")
        false
    end
  end
  
  def self.discussion_forum_parser(line, discussion)
    return case discussion['categorie'] 
      when /((\h{15,})|(i4x-#{$auteur}-#{$id_cours}-course-#{$periode}_(?<partie>\w*)))/
        if /threads\/create/.match(discussion['arg']) != nil
          puts('fil /discussion')
          f = Fil.new
          ###erreur appel de [] sur nil,
          #f.set_discuss(line)
          #f.save
          ###
          true
          true
        else
          #puts("What is this hexa discussion? #{discussion['categorie']}")
          false
        end
      when 'threads', 'comments'
        action = /(?<id_fil>\h*)\/(?<action>.*)/.match(discussion['arg'])
        case action['action']
          when 'update'
            #puts("fil /discussion : #{discussion['categorie']} update")
            f = (discussion['categorie'] == 'thread' ? Fil.find_by(myid: action['id_fil']) : Response.find_by(myid: action['id_fil']))
            if !f
              #puts("#{discussion['categorie']} inconnu jusque là ; id :#{action['id_fil']}")
              f = (discussion['categorie'] == 'thread' ? Fil.new : Response.new)
              f[:myid] = action['id_fil']
            end
            ###A dÃ©commenter, fait bugger  appel de Response.responses ???
            #f.set_discuss(line, f)
            #f.save
            ###
            true
          when 'delete'
            #puts("fil /discussion : #{discussion['categorie']} delete (id: #{action['id_fil']}")
            f = (discussion['categorie'] == 'thread' ? Fil.find_by(myid: action['id_fil']) : Response.find_by(myid: action['id_fil']))
            if f
              f.delete
              f.save
            end
            true
          when 'reply'
            #puts("fil /discussion : #{discussion['categorie']} reply (id: #{action['id_fil']}")
            f = (discussion['categorie'] == 'thread' ? Fil.find_by(myid: action['id_fil']) : Response.find_by(myid: action['id_fil']))
            if !f
              #puts("#{discussion['categorie']} inconnu jusque là ; id :#{action['id_fil']}")
              f = (discussion['categorie'] == 'thread' ? Fil.new : Response.new)
              f[:myid] = action['id_fil']
            end
            r = (discussion['categorie'] == 'thread' ? Reponse.new : Comment.new)
            ###Pareil
            #r.set_discuss(line, f)
            #r.save
            ###
            true
          when 'pin', 'follow', 'unfollow', 'upvote', 'unvote', 'close', 'flagAbuse', 'endorse'
            #puts("/discussion/#{discussion['categorie']} : #{action['action']}")
            # Penser à retirer l'élément si une utilité lui est trouvé...
            true
          else
            #puts("What is tbis discussion/#{discussion['categorie']} ? #{action['action']}")
            false
        end
      when 'upload', 'users'
        #puts("/discussion/#{discussion['categorie']}")
        true
      when 'forum'
        case discussion['arg']
          when '', 'search'
            #puts("/discussion/forum/#{discussion['arg']}")
            true
          when /(?<id_conv>\h{10,})\/(?<element>\w*)(\z|(\/(?<id_thread>\h{10,})))/
            case $LAST_MATCH_INFO['element']
              when 'inline'
                #puts("/discussion/forum/.../inline")
                true
              when 'threads'
                #puts("/discussion/forum/.../threads/...")
                true
              else
                #puts("Element de discussion/forum inconnu")
                false 
            end
          else
            #puts("What is this discussion? #{discussion['categorie']}")
            false
        end
      else
        #puts("What is this ? #{forum[:type]}")
        #puts(line)
        false
    end
  end
end