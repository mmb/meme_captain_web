class AddIndexToGendImagesIsDeleted < ActiveRecord::Migration[4.2]
  def change
    add_index :gend_images, :is_deleted
  end
end
