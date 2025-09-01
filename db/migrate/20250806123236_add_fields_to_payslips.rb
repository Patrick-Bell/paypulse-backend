class AddFieldsToPayslips < ActiveRecord::Migration[8.0]
  def change
    add_column :payslips, :year_gross, :decimal, precision: 10, scale: 2
    add_column :payslips, :year_net, :decimal, precision: 10, scale: 2
    add_column :payslips, :year_tax, :decimal, precision: 10, scale: 2
  end
end
