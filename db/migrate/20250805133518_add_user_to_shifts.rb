class AddUserToShifts < ActiveRecord::Migration[8.0]
  def change
    add_reference :shifts, :user, foreign_key: true, null: true
  end
end
