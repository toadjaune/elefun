# == Schema Information
#
# Table name: bdd_script_associations
#
#  id         :integer          not null, primary key
#  bdd_id     :integer
#  script_id  :integer
#  etat       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  log        :text
#
# Indexes
#
#  index_bdd_script_associations_on_bdd_id     (bdd_id)
#  index_bdd_script_associations_on_script_id  (script_id)
#

# Permet le lancement du script
require 'rbconfig'
require 'open3'
include Open3

class BddScriptAssociation < ActiveRecord::Base

  # Permettre le lancement asynchrone
  include Sidekiq::Worker

  def self.etats_valides
    [ 'Jamais lancé',
      'En cours',
      'En attente',
      'Réussi',
      'Échoué' ]
  end

  belongs_to :bdd
  belongs_to :script

  validates_presence_of :bdd, :script
  validates :etat,
    presence: true,
    inclusion: { in: self.etats_valides }

  before_validation do |a|
    a.etat ||= BddScriptAssociation.etats_valides[0]
  end


  def perform(script_name, opts)
    Script.where(nom: script_name).first.launch(opts)
  end
end
