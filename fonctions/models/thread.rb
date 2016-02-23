require 'neo4j'

class Thread
	include Neo4j::ActiveNode


	property :id, type: String
	property :time, type: DateTime

	property :title, type: String
	property :message, type: String

	property :category_id, type: String


	#has_one :in, :sess_creation, type: :session, model_class: :Session
	#has_many :in, :sessions, type: :session, model_class: :Session

	#manque cet élément (à voir si utile)
	#has_one :out, :page, type: :page, model_class: :Page

	def set(params)
		self.id = params['event']['id']
		self.time = params['time']
		self.title = params['event']['title']
		self.message = params['event']['body']
		self.category_id = params['event']['category_id']

		#s = Session.as(:s).where(name: params['session']).pluck(:s).first
		#if s.nil?
		#	s = Session.create(name: params['session'], agent: params['agent'])
		#end
		#self.sess_creation << s
	end
end
