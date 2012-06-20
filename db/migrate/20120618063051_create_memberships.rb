class CreateMemberships < ActiveRecord::Migration
  def change
  	create_table :memberships do |t|
      	t.references :project
      	t.references :person
      	t.timestamps
    end
    add_index :memberships, [ :project_id, :person_id ], :unique => true #prevents duplicates
  end
end
