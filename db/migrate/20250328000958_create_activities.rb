class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :kind, null: false
      t.string :category, null: false
      t.datetime :started_at
      t.integer :duration
      t.text :notes
      t.jsonb :data, default: {}

      t.timestamps
    end

    add_index :activities, :kind
    add_index :activities, :category
    add_index :activities, [:kind, :category]
  end
end
