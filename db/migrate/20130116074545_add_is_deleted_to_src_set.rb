class AddIsDeletedToSrcSet < ActiveRecord::Migration[4.2]
  def change
    add_column :src_sets, :is_deleted, :boolean, :default => false
    add_index :src_sets, :is_deleted
  end
end
