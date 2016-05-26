class InfoWeek
  include Neo4j::ActiveRel

  from_class :User
  to_class :Week
  type 'info_week'

  property :page_visited, type: Integer, default: 0
  property :quiz_answered, type: Integer, default: 0
  
  #difficile de relier semaine et threads
  property :forum_posted, type: Integer, default: 0
  property :forum_visited, type: Integer, default: 0
  
  property :video_viewed, type: Integer, default: 0
  property :activite, type:Time, default: 0
  
  def set_page_visits
    return self.from_node.as(:u).match_nodes(w: week).match('(u)-->(:Session)-[e:event]->(:Page)-->(w)').where(e: {event_type: "page_visit"}).count(:e)
  end
  
  def set_quiz_answers
    return self.from_node.as(:u).match_nodes(w: week).match('(u)-->(:Session)-[r:result]->(:Quiz)-->(w)').count(:r)
  end

  def set_forum_posts
    return self.from_node.as(:u).match_nodes(w: week).match('(u)-->(:Session)-[e:event]->(:Page)-->(w)').where(e: {event_type: "forum_post"}).count(:e)
  end
  
  def set_forum_visits
    return self.from_node.as(:u).match_nodes(w: week).match('(u)-->(:Session)-[e:event]->(:Page)-->(w)').where(e: {event_type: "forum_visit"}).count(:e)
  end

  def set_video_views
    return self.from_node.as(:u).match_nodes(w: week).match('(u)-->(:Session)-[e:event]->(:Page)-->(w)').where(e: {event_type: "play_video"}).count(:e)
  end

  #À DÉFINIR
  def set_activite
    
  end
end
