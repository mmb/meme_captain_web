class AddIndexToSrcImagesIsDeleted < ActiveRecord::Migration
  def change
    add_index :src_images, :is_deleted
  end
end
