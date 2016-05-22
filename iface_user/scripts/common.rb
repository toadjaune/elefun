#!/usr/bin/env ruby


require 'optparse'



$structure_file = ''

OptionParser.new do |opts|

  opts.banner = 'Test'

  opts.on('-s', '--structure STRUCTURE_FILE', 'Fichier de structure du MOOC') do |s|
    $structure_file = s
    puts "structure : #{s}"
  end

end.parse!

puts $structure_file

puts 'a'
