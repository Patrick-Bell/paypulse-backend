class RenameEndToFinish < ActiveRecord::Migration[8.0]
  def change
    rename_column :payslips, :end, :finish
  end
end
