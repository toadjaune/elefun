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

class Fichier < ActiveRecord::Base

  include Rails.application.routes.url_helpers

#  attr_accessible :fichier
  has_attached_file :fichier, path: 'fichiers'
  belongs_to :mooc

  validates_attachment_content_type :fichier, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

#  def new(params)
#    origin = params[:tempfile]
#    destination = '/fichiers'
#
#    if File.exists? File.join(destination, File.basename(origin))
#      FileUtils.move origin, File.join(destination, "1-#{File.basename(origin)}")
#    else
#      FileUtils.move origin, File.join(destination, File.basename(origin))
#    end
#  end


  def to_jq_upload
    {
      "name" => read_attribute(:fichier_file_name),
      "size" => read_attribute(:fichier_file_size),
      "url" => fichier.url(:original),
      "delete_url" => fichier_path(self),
      "delete_type" => "DELETE" 
    }
  end
end
