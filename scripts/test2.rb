#!/usr/bin/env ruby

require_relative 'common.rb'

i = InfoWeek.find(84645)
w = Week.find_by(number: 0)
puts w.name
puts i.video_viewed
i.set_video_views(w)
puts i.video_viewed
