class Info
  include Neo4j::ActiveRel

  from_class :User
  to_class :Week
  type 'info_week'

  property :page_visits, type: Integer, default: 0
  property :quiz_an, type: Integer, default: 0
  
  #difficile de relier semaine et threads
  property :forum_msg, type: Integer, default: 0
  property :forum_lu, type: Integer, default: 0
  
  property :video_play, type: Integer, default: 0
  property :activite, type:Time, default: 0
end
