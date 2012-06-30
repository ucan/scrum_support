class CreateExternalStoryLinks < ActiveRecord::Migration
  def change
    create_table :external_story_links do |t|
      t.integer	:linked_id
      t.references :external_project_link
      t.references :story

      t.timestamps
    end
  end
end
