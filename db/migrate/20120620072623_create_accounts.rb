class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user
      t.references :team_member
      t.string :api_token
      t.string :email
      t.string :type
      t.timestamps
    end
    add_index :accounts, :api_token, unique: true
  end
end
