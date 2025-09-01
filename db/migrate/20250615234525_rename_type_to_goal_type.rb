class RenameTypeToGoalType < ActiveRecord::Migration[8.0]
  def change
    rename_column :goals, :type, :goal_type
  end
end
