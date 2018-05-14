class CreateRemitRequestResults < ActiveRecord::Migration[5.2]
  def change
    create_table :remit_request_results do |t|
      t.bigint :user_id, null: false
      t.bigint :target_id, null: false
      t.integer :amount, null: false, limit: 4
      t.string :result, null: false, limit: 10

      t.timestamps

      t.index :user_id
      t.index :target_id
    end
  end
end
