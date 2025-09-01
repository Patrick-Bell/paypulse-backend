class AddLastUpdatedPasswordToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :password_last_updated, :datetime
  end
end
