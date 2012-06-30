class CreateExternalTaskLinks < ActiveRecord::Migration
  def change
    create_table :external_task_links do |t|
      t.integer	:linked_id
      t.references :external_story_link
      t.references :task

      t.timestamps
    end
  end
end
