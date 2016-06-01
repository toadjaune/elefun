class AddLogToBddScriptAssociation < ActiveRecord::Migration
  def change
    add_column :bdd_script_associations, :log, :text
  end
end
