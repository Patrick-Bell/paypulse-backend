class AddExpensableToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :expensable, :boolean, default: false
  end
end
