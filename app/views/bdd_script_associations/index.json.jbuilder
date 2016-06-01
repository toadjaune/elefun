json.scripts(@bdd_script_associations) do |bdd_script_association|
  json.extract! bdd_script_association, :id
  json.nom bdd_script_association.script.nom 
  json.ordre bdd_script_association.script.id
  json.extract! bdd_script_association, :etat
end
