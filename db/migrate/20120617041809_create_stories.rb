class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.references :project
      t.string :title
            
      t.timestamps
    end
  end
end
