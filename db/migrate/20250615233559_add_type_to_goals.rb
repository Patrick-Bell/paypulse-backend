class AddTypeToGoals < ActiveRecord::Migration[8.0]
  def change
    add_column :goals, :type, :string
  end
end
