class AddUserToPayslips < ActiveRecord::Migration[8.0]
  def change
    add_reference :payslips, :user, null: true, foreign_key: true
  end
end
