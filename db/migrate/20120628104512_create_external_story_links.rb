class CreateExternalStoryLinks < ActiveRecord::Migration
  def change
    create_table :external_story_links do |t|
      t.integer	:linked_id
      t.references :external_iteration_link
      t.references :story

      t.timestamps
    end
    add_index :external_story_links, [ :story_id, :linked_id ], unique: true #prevents duplicates
  end
end
