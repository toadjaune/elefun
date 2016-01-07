require 'neo4j'

db = Neo4j::Session.open(:server_db)

class Page
  include Neo4j::ActiveNode
  
  property :id, constraint: :unique
  property :type, default: 'unknown'
  property :display_name
  property :graded, type: Boolean, default: false
  property :forma, type: String, default: ""
  
  validates :display_name, presence: true
  
  has_one :in, :parent, type: :page, model_class: :Page
  has_many :out, :children, type: :page, model_class: :Page
  
  
  
=begin
  def initialize(params, blocks)
    @id = params['id']
    @type = params['type']
    @display_name = params['display_name']
    @graded = params['graded']
    @format = params['format']
    @children = []
    c = params['children']
    for child in c
      page = Page.create(blocks[child], blocks)
      @children << page
    end
    self.save
  end
=end
end

file = File.new('data/course_structure_ENSCachan_20003S02_Trimestre_1_2015.json', 'r')
cours = JSON.parse(file.gets)
#on a désormais un hash du JSON

root = cours['root']
blocks = cours['blocks']

#page racine
classe = Page.new(blocks[root])

#à remplacer par le remplissage de la BDD
file2 = File.new('data/course', 'w')

#parcours l'arborescence en prenant en argument la page racine et la profondeur
def tree(blocks, id, depth, file)
  page = Page.new(blocks[id])
  puts(page.display_name)
  file.write(depth+page.display_name+"\n")
  depth = depth + " "
  children_id = blocks[id]["children"]
  children = []
  for child_id in children_id
    child = tree(blocks, child, depth, file)
    child.save
    children << child
  end
  return page
end

tree(blocks, root, "", file2)

puts(Page.count)