class AddIsDeletedToSrcImage < ActiveRecord::Migration
  def change
    add_column :src_images, :is_deleted, :boolean, :default => false
  end
end
