class AddDescriptionToSrcImages < ActiveRecord::Migration

  def change
    add_column :src_images, :name, :text
    add_index :src_images, :name
  end

end
