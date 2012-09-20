class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.integer :current_iteration_id

      t.timestamps
    end
  end
end
