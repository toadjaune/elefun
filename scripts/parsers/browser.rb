#!/usr/bin/env ruby
module Parser
  #renvoit l'id de la page suivant les différents format possible
  def self.get_id(line)
    if line['event_type'] == "problem_check"
      return line['event'].match('problem-([a-z0-9]*)_')[1]
    elsif line['event'].is_a?(Hash) and id = line['event']['id']
      if id.match '^i4x:'
        return id.split('/').last
      else
        return id.split('-').last
      end
    else
      #a nettoyer
      if line['referer']
        return line['referer'].split('/').last
      elsif line['context']['path']
        return line['context']['path'].split('/').last
      else
        return line['page'].split('/').last
      end
    end
    return nil
  end
  
  def self.browser_parser(line, id, type)
    user,session = Parser.get_session(line)
    #on récupère l'id de la page
    page = Page.find_by(myid: id)
    if page.nil?
      #puts("error #{line['event']['id']}")
      $page_errors += 1
      return false
    else
      time = DateTime.iso8601(line['time'])
      rel = Event.create(from_node: session, to_node: page, time: time, event_type: type)
      #if line['event_type'] == "play_video"
      #  session.add_views
      #end
      $new_relations += 1
      return true
    end
  end
end
