# == Schema Information
#
# Table name: scripts
#
#  id         :integer          not null, primary key
#  nom        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rbconfig'
require 'open3'
include Open3

class Script < ActiveRecord::Base

  validates :nom, 
    presence: true,
    uniqueness: true
  validate :script_existence

  def launch(args='')
    script_file = File.expand_path("../../../scripts/#{nom}", __FILE__)
    stdout_and_stderr, status = capture2e(RbConfig.ruby, script_file, args)
    p stdout_and_stderr
    p status
  end

  private

  def script_existence
    if !File.exists?(File.expand_path("../../../scripts/#{nom}", __FILE__))
      errors.add(:nom, "doit correspondre à un script existant. [Fichier non trouvé : #{File.expand_path("#{Rails.root}/scripts/#{nom}", __FILE__)}]")
    end
  end

end
