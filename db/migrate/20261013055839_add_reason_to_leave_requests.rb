class AddReasonToLeaveRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :leave_requests, :reason, :string
  end
end
