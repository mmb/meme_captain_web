class CreateNoResultSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :no_result_searches do |t|
      t.text :query

      t.timestamps null: false
    end
  end
end
