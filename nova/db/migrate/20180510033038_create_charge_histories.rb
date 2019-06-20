class CreateChargeHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :charge_histories do |t|
      t.bigint :amount, null:false
      t.string :ch_id, null:false
      t.string :result, null:false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
