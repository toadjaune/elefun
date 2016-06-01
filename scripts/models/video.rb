class Video < Page
  #Représente les différentes pages du cours 
  
  property :views, type: Integer, default: 0
  
  def add_view
    self.views += 1
    self.save
  end
end
