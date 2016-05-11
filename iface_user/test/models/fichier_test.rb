# == Schema Information
#
# Table name: fichiers
#
#  id          :integer          not null, primary key
#  nom         :string
#  mooc_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  genre       :string
#  nom_fichier :string
#
# Indexes
#
#  index_fichiers_on_mooc_id  (mooc_id)
#

require 'test_helper'

class FichierTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
