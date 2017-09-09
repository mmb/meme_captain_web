class AddImageExternalToThumbs < ActiveRecord::Migration[5.1]
  def change
    add_column :gend_thumbs, :image_external_bucket, :text
    add_column :gend_thumbs, :image_external_key, :text
    add_column :src_thumbs, :image_external_bucket, :text
    add_column :src_thumbs, :image_external_key, :text
  end
end
