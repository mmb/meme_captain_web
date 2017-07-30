class AddDescriptionToSrcImages < ActiveRecord::Migration[4.2]

  def change
    add_column :src_images, :name, :text
    add_index :src_images, :name, length: 64
  end

end
