class AddUniqenessToChargesUserId < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :charges, :users
    remove_index :charges, column: :user_id
    add_index    :charges, :user_id, unique: true
    add_foreign_key :charges, :users
  end
end
