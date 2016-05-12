# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# On génère les objets Script en BDD à partir du contenu du dossier.
Dir.chdir 'scripts'
Dir.foreach '.' do |file|
  if File.executable?(file) && File.ftype(file) != 'directory' # Pour éliminer . et ..
    Script.create(nom: file)
  end
end
