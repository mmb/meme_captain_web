class AddIsDeletedToSrcImage < ActiveRecord::Migration[5.0]
  def change
    add_column :src_images, :is_deleted, :boolean, :default => false
  end
end
