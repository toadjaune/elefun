require 'rubygems'
require 'json'

file = File.new('data/course_structure_ENSCachan_20003S02_Trimestre_1_2015.json', 'r')
cours = JSON.parse(file.gets)
#on a désormais un hash du JSON

root = cours['root']

blocks = cours['blocks']
i = 0
for page, content in blocks
  puts(page)
  i = i+1
end
puts(i)

class Page
  attr_accessor :id, :type, :display_name, :graded, :format, :children
  def initialize(params, blocks)
    self.id = params['id']
    self.type = params['type']
    self.display_name = params['display_name']
    self.graded = params['graded']
    self.format = params['format']
    self.children = []
    c = params['children']
    for child in c
      page = Page.new(blocks[child], blocks)
      @children << page
    end
  end
end

classe = Page.new(blocks[root], blocks)

file2 = File.new('data/course', 'w')
def tree(page, offset, file)
  puts(offset+page.display_name)
  file.write(offset+page.display_name+"\n")
  offset = offset + " "
  for page in page.children
    tree(page, offset, file)
  end
end

tree(classe, "", file2)