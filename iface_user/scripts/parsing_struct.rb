#! /usr/bin/env ruby
require 'neo4j'
require 'json'
require_relative 'models/etiquetable'
require_relative 'models/page'
require_relative 'models/video'

#parcours l'arborescence en prenant en argument la page racine et la profondeur
def tree(blocks, id, depth, week)
  params = blocks[id]
  case params["type"] 
    when "dmcloud"
      page = Video.new
    #when "problem"
      #attribuer la valeur quizz
    else
      page = Page.new
  end
  
  page.set(params, depth.length, week)    
  puts(depth + page.display_name)
  depth = depth + " "
  
  children_id = params["children"]
  page.children = []
  for child_id in children_id
    child = tree(blocks, child_id, depth, week)
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
  classe.set(blocks[root], 0, "")
  cours = tree(blocks, root, "", "")
  cours.save
  puts(Page.count.to_s + " Pages")
end

p Dir.pwd

db = Neo4j::Session.open(:server_db)  
parse_struct('data/20003S02/course_structure_ENSCachan_20003S02_Trimestre_1_2015.json')
db.close()
