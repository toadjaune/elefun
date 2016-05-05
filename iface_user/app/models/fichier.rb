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

  def new(params)
    origin = params[:tempfile]
    destination = '/fichiers'

    if File.exists? File.join(destination, File.basename(origin))
      FileUtils.move origin, File.join(destination, "1-#{File.basename(origin)}")
    else
      FileUtils.move origin, File.join(destination, File.basename(origin))
    end
  end
end
