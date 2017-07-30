class AddIsDeletedToSrcImage < ActiveRecord::Migration[4.2]
  def change
    add_column :src_images, :is_deleted, :boolean, :default => false
  end
end
