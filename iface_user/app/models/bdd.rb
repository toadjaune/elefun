# == Schema Information
#
# Table name: bdds
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bdd < ActiveRecord::Base

  has_many :bdd_script_associations, dependent: :destroy
  has_many :scripts, through: :bdd_script_associations

  validate :is_linked_to_every_script

  before_validation :initialize_bdd_script_associations, on: :create


  def to_s
    id
  end

  private

  # La situation où une BDD n'est pas liée à un script n'est pas supposée avoir lieu
  def is_linked_to_every_script
    if scripts.count != Script.count
      # NB : On se repose sur la validation d'unicité du lien BDD-Script
      errors.add :scripts, 'Doit être liée à tous les scripts'
    end
  end

  # Setup automatique à la création d'un objet bdd
  # On n'a a priori pas besoin de l'équivalent côté script, la liste de scripts étant statique.
  def initialize_bdd_script_associations
    Script.all.each do |s|
      self.scripts << s
    end
  end
end
