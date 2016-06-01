# == Schema Information
#
# Table name: fichiers
#
#  id                   :integer          not null, primary key
#  mooc_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  genre                :string
#  fichier_file_name    :string
#  fichier_content_type :string
#  fichier_file_size    :integer
#  fichier_updated_at   :datetime
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
