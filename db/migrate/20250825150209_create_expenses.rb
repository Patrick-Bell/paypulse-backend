class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.integer :amount, precision: 10, scale: 2
      t.references :shift, null: false, foreign_key: true
      t.string :notes

      t.timestamps
    end
  end
end
