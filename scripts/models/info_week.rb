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
  
  def set_page_visits(week)
    self.page_visited =  self.from_node.query_as(:u).match_nodes(w: week).match('(u)-->(:Session)-[e:event]->(:Page)-->(w)').where(e: {event_type: "page_visit"}).count(:e)
  end
  
  def set_quiz_answers(week)
    self.quiz_answered =  self.from_node.query_as(:u).match_nodes(w: week).match('(u)-->(:Session)-[r:result]->(:Quiz)-->(w)').count(:r)
  end

  def set_forum_posts(week)
    self.forum_posted =  self.from_node.query_as(:u).match_nodes(w: week).match('(u)-->(:Session)-[e:event]->(:Page)-->(w)').where(e: {event_type: "forum_post"}).count(:e)
  end
  
  def set_forum_visits(week)
    self.forum_visited = self.from_node.query_as(:u).match_nodes(w: week).match('(u)-->(:Session)-[e:event]->(:Page)-->(w)').where(e: {event_type: "forum_visit"}).count(:e)
  end

  def set_video_views(week)
    self.video_viewed = self.from_node.query_as(:u).match_nodes(w: week).match('(u)-->(:Session)-[e:event]->(v:Video)-->(w)').count(:v)
  end

  #À DÉFINIR
  def set_activite
    
  end
end
