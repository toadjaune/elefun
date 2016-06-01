json.array!(@bdds) do |bdd|
  json.extract! bdd, :id
  json.url bdd_url(bdd, format: :json)
end
