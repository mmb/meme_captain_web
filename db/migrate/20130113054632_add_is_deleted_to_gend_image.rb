class AddIsDeletedToGendImage < ActiveRecord::Migration[4.2]
  def change
    add_column :gend_images, :is_deleted, :boolean, :default => false
  end
end
