require 'rubygems'
require 'json'
require 'mongoid'

class Page
  
  attr_accessor :id, :type, :display_name, :graded, :format, :children
  
  
  def initialize(params, blocks)
    @id = params['id']
    @type = params['type']
    @display_name = params['display_name']
    @graded = params['graded']
    @format = params['format']
    @children = []
    c = params['children']
    for child in c
      page = Page.new(blocks[child], blocks)
      @children << page
    end
    self.mongoize.save
  end
end

file = File.new('data/course_structure_ENSCachan_20003S02_Trimestre_1_2015.json', 'r')
cours = JSON.parse(file.gets)
#on a désormais un hash du JSON

root = cours['root']
blocks = cours['blocks']

#page racine
classe = Page.new(blocks[root], blocks)

#à remplacer par le remplissage de la BDD
file2 = File.new('data/course', 'w')

#parcours l'arborescence en prenant en argument la page racine et la profondeur
def tree(page, depth, file)
  file.write(depth+page.display_name+"\n")
  depth = depth + " "
  for page in page.children
    tree(page, depth, file)
  end
end

tree(classe, "", file2)

puts(Page.count)