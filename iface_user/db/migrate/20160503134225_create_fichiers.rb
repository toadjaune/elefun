class CreateFichiers < ActiveRecord::Migration
  def change
    create_table :fichiers do |t|
      t.string :nom
      t.belongs_to :mooc, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
