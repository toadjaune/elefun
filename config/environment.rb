# Load the Rails application.
require File.expand_path('../application', __FILE__)

Rails.application.configure do
  # Port par défaut du serveur neo4j
  config.neo4j.session_type = :server_db
  config.neo4j.session_path = 'http://localhost:7474'
end

# Initialize the Rails application.
Rails.application.initialize!
