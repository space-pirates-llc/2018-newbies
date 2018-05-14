class RemoveUnusedColumnsToRemitRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :remit_requests, :accepted_at, :datetime
    remove_column :remit_requests, :rejected_at, :datetime
    remove_column :remit_requests, :canceled_at, :datetime
  end
end
