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
#
# Indexes
#
#  index_bdd_script_associations_on_bdd_id     (bdd_id)
#  index_bdd_script_associations_on_script_id  (script_id)
#

require 'test_helper'

class BddScriptAssociationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
