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
#
# Indexes
#
#  index_moocs_on_bdd_id  (bdd_id)
#

require 'test_helper'

class MoocTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
