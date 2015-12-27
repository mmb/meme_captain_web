class AddImageHashAndAverageColor < ActiveRecord::Migration
  def change
    add_column :gend_images, :image_hash, :text
    add_index :gend_images, :image_hash, length: 40
    add_column :gend_images, :average_color, :text
    add_index :gend_images, :average_color, length: 6

    add_column :gend_thumbs, :image_hash, :text
    add_index :gend_thumbs, :image_hash, length: 40
    add_column :gend_thumbs, :average_color, :text
    add_index :gend_thumbs, :average_color, length: 6

    add_column :src_images, :image_hash, :text
    add_index :src_images, :image_hash, length: 40
    add_column :src_images, :average_color, :text
    add_index :src_images, :average_color, length: 6

    add_column :src_thumbs, :image_hash, :text
    add_index :src_thumbs, :image_hash, length: 40
    add_column :src_thumbs, :average_color, :text
    add_index :src_thumbs, :average_color, length: 6
  end
end
