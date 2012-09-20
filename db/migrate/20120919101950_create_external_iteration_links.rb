class CreateExternalIterationLinks < ActiveRecord::Migration
  def change
    create_table :external_iteration_links do |t|
      t.integer	:linked_id
      t.references :external_project_link
      t.references :iteration

      t.timestamps
    end
    add_index :external_iteration_links, [ :iteration_id, :linked_id ], unique: true #prevents duplicates
  end
end
