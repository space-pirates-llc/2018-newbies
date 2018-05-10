class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.bigint :user_id, null: false
      t.integer :balance, default: 0

      t.timestamps
    end
  end
end
