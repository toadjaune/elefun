class CreateBddScriptAssociations < ActiveRecord::Migration
  def change
    create_table :bdd_script_associations do |t|
      t.belongs_to :bdd, index: true, foreign_key: true
      t.belongs_to :script, index: true, foreign_key: true
      t.string :etat

      t.timestamps null: false
    end
  end
end
