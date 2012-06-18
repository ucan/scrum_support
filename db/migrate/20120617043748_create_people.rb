class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :firstName
      t.string :lastName
      t.string :email
      t.string :username

      t.timestamps
    end
  end
end
