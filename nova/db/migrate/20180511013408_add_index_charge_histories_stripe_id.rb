class AddIndexChargeHistoriesStripeId < ActiveRecord::Migration[5.2]
  def change
    add_index :charge_histories, :stripe_id, :unique => true
  end
end
