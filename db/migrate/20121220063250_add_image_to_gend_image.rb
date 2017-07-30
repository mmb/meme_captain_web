class AddImageToGendImage < ActiveRecord::Migration[4.2]
  def change
    add_column :gend_images, :image, :binary
  end
end
