class RenameChIdColumnToStripeId < ActiveRecord::Migration[5.2]
  def change
    rename_column :charge_histories, :ch_id, :stripe_id
  end
end
