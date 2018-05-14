class ChangeColumnsToRemitRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :remit_requests, :status, :integer, null: false, default: "outstanding"

    remove_column :remit_requests, :accepted_at, :datetime
    remove_column :remit_requests, :rejected_at, :datetime
    remove_column :remit_requests, :canceled_at, :datetime
  end
end
