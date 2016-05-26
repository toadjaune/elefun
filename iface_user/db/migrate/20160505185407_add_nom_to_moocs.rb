class AddNomToMoocs < ActiveRecord::Migration
  def change
    add_column :moocs, :nom, :string
  end
end
