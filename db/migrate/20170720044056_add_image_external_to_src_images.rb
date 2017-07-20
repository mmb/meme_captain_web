class AddImageExternalToSrcImages < ActiveRecord::Migration[5.0]
  def change
    add_column :src_images, :image_external_bucket, :text
    add_column :src_images, :image_external_key, :text
  end
end
