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

class BddScriptAssociation < ActiveRecord::Base
  belongs_to :bdd
  belongs_to :script

  validates_presence_of :bdd, :script
end
