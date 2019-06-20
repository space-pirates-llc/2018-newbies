class AddIndexToCharges < ActiveRecord::Migration[5.2]
  def change
    add_index :charges, :ch_id, unique: true
  end
end
