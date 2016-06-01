json.array!(@moocs) do |mooc|
  json.extract! mooc, :id, :auteur, :id_cours, :periode, :bdd_id
  json.url mooc_url(mooc, format: :json)
end
