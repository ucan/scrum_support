class CreateAccountExternalProjectLinks < ActiveRecord::Migration
  def change
    create_table :accounts_external_project_links do |t|
      t.references :account
      t.references :external_project_link
    end
  end
end
