json.array!(@fichiers) do |fichier|
  json.extract! fichier, :id, :nom, :mooc_id
  json.url fichier_url(fichier, format: :json)
end
