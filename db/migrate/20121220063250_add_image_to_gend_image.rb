class AddImageToGendImage < ActiveRecord::Migration
  def change
    add_column :gend_images, :image, :binary
  end
end
