#!/usr/bin/env ruby

require_relative 'common'

def print_fil(fil)
  puts('________')
  puts(fil.title.upcase)
  puts(fil.message)
  puts('________')
end

def print_response(response)
  puts('  ' + response.message)
  puts('________')
end

def print_comment(comment)
  puts('    ' + comment.message)
  puts('________')
end

puts(Fil.all.count)

fils = Fil.all
fils.each do |f|
  print_fil(f)
  f.responses.each do |r|
    print_response(r)
    r.comments.each do |c|
      print_comment(c)
    end
  end
end
