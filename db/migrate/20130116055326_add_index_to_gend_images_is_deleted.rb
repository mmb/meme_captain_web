class AddIndexToGendImagesIsDeleted < ActiveRecord::Migration
  def change
    add_index :gend_images, :is_deleted
  end
end
