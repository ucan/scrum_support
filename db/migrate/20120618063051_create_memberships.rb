class CreateMemberships < ActiveRecord::Migration
  def change
  	create_table :memberships do |t|
      	t.references :project
      	t.references :person
      	t.timestamps
    end
  end
end
