#!/usr/bin/env ruby
module Parser
  #renvoit l'id de la page suivant les différents format possible
  def self.get_id(line)
    if line['event'].is_a?(Hash) and id = line['event']['id']
      if id.match '^i4x:'
        return id.split('/').last
      else
        return id.split('-').last
      end
    else
      return line['page'].split('/').last
    end
    return nil
  end
  
  def self.browser_parser(line)
    ### GET SESSIONS
    #on cherche si on connait le user
    user = User.find_by(user_id: line['context']['user_id'])
    if user then
      #si oui, on cherche si l'on connait déjà la session actuelle
      s = user.sessions.as(:s).where(name: line['session']).pluck(:s).first
      if s.nil?
        #sinon on la crée
        s = Session.create({name: line['session'], agent: line['agent']})
        $new_sessions += 1
        user.sessions << s
        user.save
      end
    else
      #on crée le user s'il n'existe pas déjà
      user = User.create({username: line['username'], user_id: line['context']['user_id']})
      $new_users += 1
      s = Session.as(:s).where(name: line['session']).pluck(:s).first
      if s.nil? and !line['session'].empty?
        #cas normal
        s = Session.create(name: line['session'], agent: line['agent'])
        $new_sessions += 1
      else
        # la session appartient à plus d'un user ou nom vide
        $session_errors += 1
      end
      user.sessions << s
    user.save
    end
    ###

    #on récupère l'id de la page
    page = Page.find_by(myid: Parser.get_id(line))
    if page.nil?
      puts("error #{line['event_type']}")
      $page_errors += 1
      return false
    else
      time = DateTime.iso8601(line['time'])
      rel = Event.create(from_node: s, to_node: page, time: time, event_type: line['event_type'], org_id: line['context']['org_id'], path: line['context']['path'], page: line['page'])
      $new_relations += 1
      return true
    end
  end
end