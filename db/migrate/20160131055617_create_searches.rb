class CreateSearches < ActiveRecord::Migration[4.2]
  def change
    create_table :searches do |t|
      t.text :query, null: false
      t.integer :result_count, null: false

      t.timestamps null: false
    end

    add_index :searches, :result_count
    add_index :searches, :created_at
  end
end
