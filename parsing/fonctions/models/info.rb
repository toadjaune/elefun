require 'neo4j'
require 'date'

class Info
  include Neo4j::ActiveRel

  from_class :User
  to_class :Week
  type 'info'

  property :page_visitees, type: Integer, date: 0
  property :m_visites, type: Integer, date: 0
  property :forum_msg, type: Integer, date: 0
  property :video_play, type: Integer, date: 0



end


