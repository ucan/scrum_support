class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description
      t.string :status
      t.references :story

      t.timestamps
    end
    add_index :tasks, :story_id
  end
end
