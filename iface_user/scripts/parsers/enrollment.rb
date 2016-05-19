#!/usr/bin/env ruby
module Parser
  def self.enrollment_parser(line)
    if !line['event'].nil? and !line['event']['POST']['csrfmiddlewaretoken'].nil?  
      u = User.find_by(username: line['event']['POST']['username'])
      if u.nil?
        u = User.new
        u.set(line['event']['POST'])
        u.save
        $new_users_enroll += 1
      #else
        #doublon
      end
      return true
    else
      return false         
    end
  end
end