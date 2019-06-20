class RenameChIdColumnToCharges < ActiveRecord::Migration[5.2]
  def change
    rename_column :charges, :ch_id, :stripe_id
  end
end
