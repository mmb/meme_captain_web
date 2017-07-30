class AddImageToGendImage < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :image, :binary
  end
end
