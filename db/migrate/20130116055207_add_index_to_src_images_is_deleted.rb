class AddIndexToSrcImagesIsDeleted < ActiveRecord::Migration[4.2]
  def change
    add_index :src_images, :is_deleted
  end
end
