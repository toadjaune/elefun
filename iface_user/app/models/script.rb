# == Schema Information
#
# Table name: scripts
#
#  id         :integer          not null, primary key
#  nom        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Script < ActiveRecord::Base

  has_many :bdd_script_association, dependent: :destroy

  validates :nom, 
    presence: true,
    uniqueness: true
  validate :script_existence

  def to_s
    nom
  end

  private

  def script_existence
    file = File.expand_path("../../../scripts/#{nom}", __FILE__)
    if !File.exists?(file) || File.ftype(file) == 'directory'
      errors.add(:nom, "doit correspondre à un script existant. [Fichier non trouvé : #{File.expand_path("#{Rails.root}/scripts/#{nom}", __FILE__)}]")
    end
  end

end
