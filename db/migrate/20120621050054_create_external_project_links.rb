class CreateExternalProjectLinks < ActiveRecord::Migration
  def change
    create_table :external_project_links do |t|
      t.integer	:linked_id
      t.references :project

      t.timestamps
    end
    add_index :external_project_links, [ :project_id, :linked_id ], :unique => true #prevents duplicates
  end
end
