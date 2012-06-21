class CreateProjectMappings < ActiveRecord::Migration
  def change
    create_table :project_mappings do |t|
      t.integer	:linked_id
      t.references :account
      t.references :project

      t.timestamps
    end
    add_index :project_mappings, [ :project_id, :linked_id ], :unique => true #prevents duplicates
  end
end
