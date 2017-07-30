class AddIsDeletedToGendImage < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :is_deleted, :boolean, :default => false
  end
end
