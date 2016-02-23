require 'neo4j'

class Comment
	include Neo4j::ActiveNode


	property :id, type: String
	property :time, type: DateTime

	property :message, type: String

	property :category_id, type: String

	has_one :in, :response, type: :response

	# ajout des sessions...

	# et des cours auxquels ça fait référence

	def set(params)
		self.id = params['event']['id']
		self.time = params['time']
		self.message = params['event']['body']
		self.category_id = params['event']['category_id']

		r = Response.as(:r).where(name: params['event']['response']['id']).pluck(:r).first
		self.response << r

	end
end
