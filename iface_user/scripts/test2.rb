#!/usr/bin/env ruby

require_relative 'common.rb'

puts Regroup::Sessions.forum_participation(-1,2)
puts Session.count