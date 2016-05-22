#!/usr/bin/env ruby

Session.all.each do |s|
  s.set_quiz
end
