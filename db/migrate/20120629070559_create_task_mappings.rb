class CreateTaskMappings < ActiveRecord::Migration
  def change
    create_table :task_mappings do |t|
      t.integer	:linked_id
      t.references :story_mapping
      t.references :task

      t.timestamps
    end
  end
end
