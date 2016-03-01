#! /usr/bin/env ruby
require 'neo4j'
require 'json'
require_relative 'models/page'

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

def parse_struct(filename)
  file =  File.new(filename, 'r')
  cours = JSON.parse(file.gets)
  #on a désormais un hash du JSON
  root = cours['root']
  blocks = cours['blocks']
  #page racine
  classe = Page.new
  classe.set(blocks[root])
  cours = tree(blocks, root, "")
  cours.save
  puts(Page.count.to_s + " Pages")
end

db = Neo4j::Session.open(:server_db)  
parse_struct('data/20003S02/course_structure_ENSCachan_20003S02_Trimestre_1_2015.json')
db.close()
	
