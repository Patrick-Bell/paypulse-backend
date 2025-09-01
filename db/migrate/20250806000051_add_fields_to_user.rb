class AddFieldsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :member, :boolean, default: false
    add_column :users, :member_since, :date
    add_column :users, :email_verified, :boolean, default: false
  end
end
