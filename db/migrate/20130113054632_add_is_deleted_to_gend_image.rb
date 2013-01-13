class AddIsDeletedToGendImage < ActiveRecord::Migration
  def change
    add_column :gend_images, :is_deleted, :boolean, :default => false
  end
end
