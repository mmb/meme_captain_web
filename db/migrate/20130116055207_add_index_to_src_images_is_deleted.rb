class AddIndexToSrcImagesIsDeleted < ActiveRecord::Migration[5.0]
  def change
    add_index :src_images, :is_deleted
  end
end
