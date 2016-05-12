require 'neo4j'

class Quiz < Page
  #Représente un des quiz du cours
  include Neo4j::ActiveNode
  
  has_many :in, :users, rel_class: :Result
  
  def to_s
    return "[QUIZ] name: "+self.display_name
  end
  def self.combine_quiz_results
    #aditionne les résultats des questions des quizs mal créés
    #choisir entre parcourir les quiz puis les user ou l'inverse
    # ensuite parcourir toutes les question(fils) de chaque quiz
    # et sommer les :grade et les grade_max ensemble
  end
end