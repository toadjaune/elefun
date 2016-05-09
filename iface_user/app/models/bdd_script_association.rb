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

  validates :bdd,
    presence: true,
    uniqueness: { scope: :script,
                  message: 'Cette BDD est déjà liée à ce script' } # On vérifie que le lien BDD-Script est unique
  validates :script,
    presence: true,
    uniqueness: { scope: :bdd,
                  message: 'Cette BDD est déjà liée à ce script' }
  validates :etat,
    presence: true,
    inclusion: { in: self.etats_valides }

  before_validation do |a|
    a.etat ||= BddScriptAssociation.etats_valides[0]
  end

  # Cette méthode est un wrapper pour le lancement du script
  # Elle renvoie nil s'il a correctement été lancé, un message d'erreur sinon
  def launch(opts='')
    if etat == 'En cours' || etat == 'En attente'
      return 'Impossible de lancer ce script pour le moment'
    end
    self.etat = 'En attente'
    save!
    BddScriptAssociation.perform_async(id,opts)
    nil
  end

  # NB : On n'appelle jamais perform directement, mais plutôt BddScriptAssociation.perform_async, qui est une méthode de classe et non d'instance.
  # On a donc besoin d'un id en argument pour savoir quel script exécuter.
  # Notons qu'en principe, il faudrait isoler ça dans un classe à part (app/workers ...), mais ça ne semble pas marcher, on le fait donc un peu manuellement.
  def perform(bdd_script_association, opts)
    association = BddScriptAssociation.find(bdd_script_association)
    script = association.script
    script_file = File.expand_path("../../../scripts/#{script.nom}", __FILE__)
    association.etat = 'En cours'
    association.save!
    stdout_and_stderr, status = capture2e(RbConfig.ruby, script_file, opts)
    association.log = stdout_and_stderr
    if status.exitstatus == 0
      association.etat = 'Réussi'
    else
      association.etat = 'Échoué'
    end
    association.save!
  end

end
