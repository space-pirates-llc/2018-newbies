class AddPasswordDigestColToUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :password, :string
    add_column :users, :password_digest, :string, null: false, after: :email
  end
end
