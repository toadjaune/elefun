require 'neo4j'
require 'date'

class Info
  include Neo4j::ActiveRel

  from_class :User
  to_class :Week
  type 'info'

  property :page_visitees, type: Integer, default: 0
  property :n_visites, type: Integer, default: 0
  property :forum_msg, type: Integer, default: 0
  property :video_play, type: Integer, default: 0
  property :activite, type:Time, default: 0
end