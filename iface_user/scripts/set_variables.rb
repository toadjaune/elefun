#!/usr/bin/env ruby

require_relative 'common'

start = Time.now

Session.all.each do |s|
  s.set_video_views
  s.set_quiz_answers
  s.set_forum_visits
  s.set_forum_posts
  s.set_page_visits
end

duration = Time.now - start
puts("durée (en min) : #{duration/60}")

