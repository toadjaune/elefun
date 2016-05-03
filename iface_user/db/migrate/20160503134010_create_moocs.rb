class CreateMoocs < ActiveRecord::Migration
  def change
    create_table :moocs do |t|
      t.string :auteur
      t.string :id_cours
      t.string :periode
      t.belongs_to :bdd, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
