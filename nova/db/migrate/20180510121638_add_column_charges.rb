class AddColumnCharges < ActiveRecord::Migration[5.2]
  def change
    add_column :charges, :ch_id, :string
  end
end
