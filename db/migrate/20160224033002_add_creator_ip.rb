class AddCreatorIp < ActiveRecord::Migration[4.2]
  def change
    add_column :gend_images, :creator_ip, :text
    add_column :src_images, :creator_ip, :text
  end
end
