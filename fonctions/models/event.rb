require 'neo4j'
require 'date'
require_relative 'session'
require_relative 'page'

class Event
  include Neo4j::ActiveRel
  
  from_class :Session
  to_class :Page
  type 'visited'
  
  property :event_type, type: String
  property :time, type: DateTime
  
  #context
  property :org_id, type:   Integer
  property :path, type: String
  
  #event
  property :event_id, type: String
  property :event_POST, type: String
  property :event_GET, type: String
  
  property :page, type: String
  
  property :event_source, type: String
  
  validates_presence_of :time, :event_source
  
end