class CreateShifts < ActiveRecord::Migration[8.0]
  def change
    create_table :shifts do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :finish_time
      t.decimal :rate, precision: 10, scale: 2     # e.g., up to 99999999.99
      t.decimal :pay, precision: 10, scale: 2      # money values
      t.string :notes
      t.decimal :hours, precision: 5, scale: 2     # e.g., up to 999.99 hours
      t.string :client
      t.string :location
      t.date :date

      t.timestamps
    end
  end
end
