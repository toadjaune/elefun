#!/usr/bin/env ruby
require_relative 'common'

require_relative 'common'

start = Time.now
"Début cacul des variables de sessions"
nb = 0
Session.all.each do |s|
  nb += 1
  s.set_video_views
  s.set_quiz_answers
  s.set_forum_visits
  s.set_forum_posts
  s.set_page_visits
end
puts "#{nb} sessions traitées"
duration = Time.now - start
puts("durée (en min) : #{duration/60}")

start = Time.now
"Début créations des infos_week"
nb = 0
weeks = Week.all
User.all.each do |u|
  weeks.each do |w|
    nb += 1
    info = InfoWeek.create(from_node: u, to_node: w)
    info.set_page_visits(w)
    info.set_quiz_answers(w)
    
    info.set_forum_posts(w)
    info.set_forum_visits(w)
    
    info.set_video_views(w)
    
    #À DÉFINIR
    info.set_activite
    info.save
  end
end
puts "#{nb} users traités"
duration = Time.now - start
puts("durée (en min) : #{duration/60}")
