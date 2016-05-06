# == Schema Information
#
# Table name: fichiers
#
#  id         :integer          not null, primary key
#  nom        :string
#  mooc_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_fichiers_on_mooc_id  (mooc_id)
#

class Fichier < ActiveRecord::Base
  belongs_to :mooc
end
