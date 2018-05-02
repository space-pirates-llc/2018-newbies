# frozen_string_literal: true

class InitSchema < ActiveRecord::Migration[5.1]
  def up
    create_table 'charges', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4' do |t|
      t.bigint 'user_id', null: false
      t.integer 'amount', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['user_id'], name: 'index_charges_on_user_id'
    end

    create_table 'credit_cards', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4' do |t|
      t.bigint 'user_id', null: false
      t.string 'brand', null: false
      t.string 'last4', null: false
      t.integer 'exp_year', null: false
      t.integer 'exp_month', null: false
      t.string 'stripe_id', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['user_id'], name: 'index_credit_cards_on_user_id'
    end

    create_table 'remit_requests', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4' do |t|
      t.bigint 'user_id', null: false
      t.bigint 'target_id', null: false
      t.integer 'amount', null: false
      t.datetime 'accepted_at'
      t.datetime 'rejected_at'
      t.datetime 'canceled_at'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['target_id'], name: 'index_remit_requests_on_target_id'
      t.index ['user_id'], name: 'index_remit_requests_on_user_id'
    end

    create_table 'users', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4' do |t|
      t.string 'nickname', null: false
      t.string 'email', null: false
      t.string 'password', null: false
      t.string 'stripe_id'
      t.boolean 'staff', default: false, null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end

    add_foreign_key 'charges', 'users'
    add_foreign_key 'credit_cards', 'users'
    add_foreign_key 'remit_requests', 'users'
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'The initial migration is not revertable'
  end
end
