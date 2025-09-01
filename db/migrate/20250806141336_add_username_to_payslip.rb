class AddUsernameToPayslip < ActiveRecord::Migration[8.0]
  def change
    add_column :payslips, :username, :string
  end
end
