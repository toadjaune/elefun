#!/usr/bin/env ruby
module Parser 
  def self.get_user(line)
    user = User.find_by(username: line['username'])
    if user
      if user.user_id.blank?
        user.update(user_id: line['context']['user_id'])
      end
    else
      user = User.find_by(user_id: line['context']['user_id'])
      if user.nil?
        user = User.create({username: line['username'], user_id: line['context']['user_id']})
        $new_users += 1
      end
    end
    return user
  end
  
  def self.get_session(line)
    #on cherche si on connait le user
    user = User.find_by(username: line['username'])
    if user then
      #si oui, on cherche si l'on connait déjà la session actuelle
      s = user.sessions.as(:s).where(name: line['session']).pluck(:s).first
      if s.nil?
        #sinon on la crée
        s = Session.create({name: line['session'], agent: line['agent'], date_debut: line['time']})
        $new_sessions += 1
        user.sessions << s
        user.save
      else 
        if s.date_fin.to_time+$inactivite < line['time'].to_datetime.to_time then
          s.end
          s = Session.create({name: line['session'], agent: line['agent'], date_debut: line['time']})
          $new_sessions +=1
          user.sessions << s
          user.save
        end
      end
      if user.user_id.blank?
        user.update(user_id: line['context']['user_id'])
      end
    else
      user = User.find_by(user_id: line['context']['user_id'])
      if user
        s = user.sessions.as(:s).where(name: line['session']).pluck(:s).first
        if s.nil?
          #sinon on la crée
          s = Session.create({name: line['session'], agent: line['agent'], date_debut: line['time']})
          $new_sessions += 1
          user.sessions << s
        else 
          if s.date_fin.to_time+$inactivite < line['time'].to_datetime.to_time then
            s.end
            s = Session.create({name: line['session'], agent: line['agent'], date_debut: line['time']})
            $new_sessions +=1
            user.sessions << s
            user.save
          end
        end
        #si on est dans ce cas le username est vide donc :
        user.username = line['username']
        user.save
      else
        #on crée le user s'il n'existe pas déjà
        user = User.create({username: line['username'], user_id: line['context']['user_id']})
        $new_users += 1
        s = Session.as(:s).where(name: line['session']).pluck(:s).first
        if s.nil? and !line['session'].empty?
          #cas normal
          s = Session.create({name: line['session'], agent: line['agent'], date_debut: line['time']})
          $new_sessions += 1
        else
          # la session appartient à plus d'un user
          $session_errors += 1
        end
        user.sessions << s
        user.save
      end
    end
      return user, s
  end
end