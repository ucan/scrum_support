class CreateStoryMappings < ActiveRecord::Migration
  def change
    create_table :story_mappings do |t|
      t.integer	:linked_id
      t.references :project_mapping
      t.references :story

      t.timestamps
    end
  end
end
