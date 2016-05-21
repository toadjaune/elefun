#!/usr/bin/env ruby
require 'json'
require 'neo4j'
require 'date'

require_relative 'models/event'
require_relative 'models/user'
require_relative 'models/session'
require_relative 'models/page'
require_relative 'models/fil'
require_relative 'models/response'
require_relative 'models/comment'

require_relative 'models/quiz'
require_relative 'models/question'
require_relative 'models/result'

require_relative 'parsers/problem'
require_relative 'parsers/user_session'
require_relative 'parsers/enrollment'
require_relative 'parsers/forum'
require_relative 'parsers/browser'

db = Neo4j::Session.open(:server_db)

Session.all.each do |s|
  s.set_quiz
end