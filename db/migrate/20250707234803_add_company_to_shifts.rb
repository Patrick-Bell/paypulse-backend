class AddCompanyToShifts < ActiveRecord::Migration[8.0]
  def change
    add_column :shifts, :company, :string
  end
end
