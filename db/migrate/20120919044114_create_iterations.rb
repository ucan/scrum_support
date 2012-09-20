class CreateIterations < ActiveRecord::Migration
  def change
    create_table :iterations do |t|
      t.references :project
      t.timestamps
    end
  end
end
