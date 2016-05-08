json.array!(@bdd_script_associations) do |bdd_script_association|
  json.extract! bdd_script_association, :id
  json.url bdd_script_association_url(bdd_script_association, format: :json)
end
