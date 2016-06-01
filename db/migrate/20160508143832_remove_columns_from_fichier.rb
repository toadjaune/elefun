class RemoveColumnsFromFichier < ActiveRecord::Migration
  def change
    remove_column :fichiers, :nom, :string
    remove_column :fichiers, :nom_fichier, :string
  end
end
