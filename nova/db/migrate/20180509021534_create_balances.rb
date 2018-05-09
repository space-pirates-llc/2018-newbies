class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :amount, null: false

      t.timestamps
    end
  end
end
