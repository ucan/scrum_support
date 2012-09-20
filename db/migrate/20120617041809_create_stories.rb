class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.references :iteration
      t.string :title

      t.timestamps
    end
  end
end
