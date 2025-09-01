class CreateGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :goals do |t|
      t.string :title
      t.date :start_date
      t.date :finish_date
      t.integer :target
      t.string :period

      t.timestamps
    end
  end
end
