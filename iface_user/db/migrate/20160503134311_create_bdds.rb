class CreateBdds < ActiveRecord::Migration
  def change
    create_table :bdds do |t|

      t.timestamps null: false
    end
  end
end
