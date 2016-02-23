require 'neo4j'

class Response
	include Neo4j::ActiveNode


	property :id, type: String
	property :time, type: DateTime

	property :message, type: String

	property :category_id, type: String

	has_one :in, :thread, type: :thread
	has_many :out, :comments, type: :comment

	# ajout des sessions...

	# et des cours auxquels ça fait référence

	def set(params)
		self.id = params['event']['id']
		self.time = params['time']
		self.message = params['event']['body']
		self.category_id = params['event']['category_id']

		t = Thread.as(:t).where(name: params['event']['discussion']['id']).pluck(:t).first
		self.thread << t

	end
end
