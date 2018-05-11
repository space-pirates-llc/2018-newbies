class RenameColumnsToRemitRequest < ActiveRecord::Migration[5.2]
  def change
    rename_column :remit_requests, :target_id, :requested_user_id

    rename_column :remit_request_results, :target_id, :requested_user_id
  end
end
