class AddIsAnimatedToSrcImages < ActiveRecord::Migration[5.0]
  def change
    add_column :src_images, :is_animated, :boolean, default: false
    add_index :src_images, :is_animated
  end
end
