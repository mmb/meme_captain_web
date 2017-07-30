class AddImageFieldsToGendImage < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :height, :integer
    add_column :gend_images, :size, :integer
    add_column :gend_images, :width, :integer
  end
end
