class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user
      t.string :api_token
      t.string :type
      t.timestamps
    end
  end
end
