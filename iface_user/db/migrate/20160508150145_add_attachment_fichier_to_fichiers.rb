class AddAttachmentFichierToFichiers < ActiveRecord::Migration
  def self.up
    change_table :fichiers do |t|
      t.attachment :fichier
    end
  end

  def self.down
    remove_attachment :fichiers, :fichier
  end
end
