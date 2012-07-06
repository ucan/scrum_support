class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :project
      t.references :team_member
      t.timestamps
    end
    add_index :memberships, [ :project_id, :team_member_id ], unique: true #prevents duplicates
  end
end
