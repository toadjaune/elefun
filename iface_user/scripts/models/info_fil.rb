class Info
  include Neo4j::ActiveRel

  from_class :User
  to_class :Fil
  type 'info_fil'

  property :creator, type: Boolean, default: false
  property :nb_posts, type: Integer, default: 0
  property :nb_visites, type: Integer, default: 0

end
