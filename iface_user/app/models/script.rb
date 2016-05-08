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

  validates :nom, 
    presence: true,
    uniqueness: true
  validate :script_existence

  def to_s
    nom
  end

  private

  def script_existence
    if !File.exists?(File.expand_path("../../../scripts/#{nom}", __FILE__))
      errors.add(:nom, "doit correspondre à un script existant. [Fichier non trouvé : #{File.expand_path("#{Rails.root}/scripts/#{nom}", __FILE__)}]")
    end
  end

end
