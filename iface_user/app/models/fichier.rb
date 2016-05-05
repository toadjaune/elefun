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
