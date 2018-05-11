class ChangeColumnToCharges < ActiveRecord::Migration[5.2]
  def change
    change_column_null :charges, :stripe_id, false
  end
end
