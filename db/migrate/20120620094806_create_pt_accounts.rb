class CreatePtAccounts < ActiveRecord::Migration
  def change
    create_table :pt_accounts do |t|
    	
      t.timestamps
    end
  end
end
