class AddInvitedByToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users,:invited_by, :bigint
    add_column :users, :type, :string
  end
end
