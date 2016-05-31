# == Schema Information
#
# Table name: moocs
#
#  id         :integer          not null, primary key
#  auteur     :string
#  id_cours   :string
#  periode    :string
#  bdd_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  nom        :string
#
# Indexes
#
#  index_moocs_on_bdd_id  (bdd_id)
#

class Mooc < ActiveRecord::Base
  has_many :fichiers, dependent: :destroy
  belongs_to :bdd, dependent: :destroy

  validates_presence_of   :auteur, :id_cours, :periode, :bdd
  validates_uniqueness_of          :id_cours,           :bdd

  before_validation :set_bdd, on: :create

  def fichier_log
    fichiers.where(genre: 'log').first
  end

  def fichier_structure
    fichiers.where(genre: 'structure').first
  end

  def to_s
    nom
  end

  private

  def set_bdd
    self.bdd = Bdd.new
  end

end
