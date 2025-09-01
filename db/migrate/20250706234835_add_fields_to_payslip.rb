class AddFieldsToPayslip < ActiveRecord::Migration[8.0]
  def change
    add_column :payslips, :start, :string
    add_column :payslips, :end, :string
  end
end
