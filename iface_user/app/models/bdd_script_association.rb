class BddScriptAssociation < ActiveRecord::Base
  belongs_to :bdd
  belongs_to :script
end
