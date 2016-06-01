class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :nom

      t.timestamps null: false
    end
  end
end
