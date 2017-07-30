class DropSearches < ActiveRecord::Migration[5.0]
  def change
    drop_table :searches
  end
end
