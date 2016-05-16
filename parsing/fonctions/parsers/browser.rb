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
      return line['page'].split('/').last
    end
    return nil
  end
  
  def self.browser_parser(line, user, session)
    #on récupère l'id de la page
    page = Page.find_by(myid: Parser.get_id(line))
    if page.nil?
      #puts("error #{line['event']['id']}")
      $page_errors += 1
      return false
    else
      time = DateTime.iso8601(line['time'])
      rel = Event.create(from_node: session, to_node: page, time: time, event_type: line['event_type'], org_id: line['context']['org_id'], path: line['context']['path'], page: line['page'])
      $new_relations += 1
      return true
    end
  end
end
