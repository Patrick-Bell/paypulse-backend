class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :role
      t.string :company
      t.string :location
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
