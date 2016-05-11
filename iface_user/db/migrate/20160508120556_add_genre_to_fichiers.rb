class AddGenreToFichiers < ActiveRecord::Migration
  def change
    add_column :fichiers, :genre, :string
    add_column :fichiers, :nom_fichier, :string
  end
end
