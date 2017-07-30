class DropSearches < ActiveRecord::Migration[4.2]
  def change
    drop_table :searches
  end
end
