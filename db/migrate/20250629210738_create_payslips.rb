class CreatePayslips < ActiveRecord::Migration[8.0]
  def change
    create_table :payslips do |t|
      t.string :name
      t.string :month
      t.string :year
      t.decimal :gross, precision: 10, scale: 2
      t.decimal :net, precision: 10, scale: 2
      t.integer :hours
      t.decimal :tax, precision: 10, scale: 2
      t.string :shifts
      t.integer :rate
      t.string :status

      t.timestamps
    end
  end
end

