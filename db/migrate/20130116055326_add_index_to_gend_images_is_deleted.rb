class AddIndexToGendImagesIsDeleted < ActiveRecord::Migration[5.0]
  def change
    add_index :gend_images, :is_deleted
  end
end
