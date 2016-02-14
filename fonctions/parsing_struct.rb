#! /usr/bin/env ruby
require 'neo4j'
require 'json'
require_relative 'models/page'



db = Neo4j::Session.open(:server_db)
file = File.new('data/20003S02/course_structure_ENSCachan_20003S02_Trimestre_1_2015.json', 'r')
cours = JSON.parse(file.gets)
#on a désormais un hash du JSON

root = cours['root']
blocks = cours['blocks']

#page racine
classe = Page.new
classe.set(blocks[root])

#parcours l'arborescence en prenant en argument la page racine et la profondeur
def tree(blocks, id, depth)
  page = Page.new
  page.set(blocks[id])
	puts(depth + page.display_name)
  depth = depth + " "
  children_id = blocks[id]["children"]
  page.children = []
  for child_id in children_id
    child = tree(blocks, child_id, depth)
    child.save
    page.children << child
  end
  return page
end

cours = tree(blocks, root, "")
cours.save
puts(Page.count.to_s + " Pages")
db.close()
	
