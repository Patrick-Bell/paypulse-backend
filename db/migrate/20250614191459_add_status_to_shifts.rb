class AddStatusToShifts < ActiveRecord::Migration[8.0]
  def change
    add_column :shifts, :status, :string
  end
end
