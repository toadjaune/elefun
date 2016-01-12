#! /usr/bin/env ruby
require 'neo4j'
require 'json'
require_relative 'page'


db = Neo4j::Session.open(:server_db)
db.query("MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE r, n")
puts(Page.count.to_s + " Pages")
puts("DB cleared !")

file = File.new('../data/course_structure_ENSCachan_20003S02_Trimestre_1_2015.json', 'r')
cours = JSON.parse(file.gets)
#on a désormais un hash du JSON

root = cours['root']
blocks = cours['blocks']

#page racine
classe = Page.new(blocks[root])

#à remplacer par le remplissage de la BDD
file2 = File.new('../data/course', 'w')

#parcours l'arborescence en prenant en argument la page racine et la profondeur
def tree(blocks, id, depth, file)
  page = Page.new(blocks[id])
  file.write(depth+page.display_name+"\n")
  depth = depth + " "
  children_id = blocks[id]["children"]
  page.children = []
  for child_id in children_id
    child = tree(blocks, child_id, depth, file)
    child.save
    page.children << child
  end
  return page
end

cours = tree(blocks, root, "", file2)
cours.save
puts(Page.count.to_s + " Pages")
db.close()
	
