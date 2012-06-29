class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :auth_token
      t.references :user
      t.timestamps
    end

    add_index :api_keys, :auth_token, :unique => true
  end
end
