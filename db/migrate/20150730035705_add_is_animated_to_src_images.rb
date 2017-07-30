class AddIsAnimatedToSrcImages < ActiveRecord::Migration[4.2]
  def change
    add_column :src_images, :is_animated, :boolean, default: false
    add_index :src_images, :is_animated
  end
end
