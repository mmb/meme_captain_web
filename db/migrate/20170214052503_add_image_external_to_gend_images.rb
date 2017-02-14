class AddImageExternalToGendImages < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :image_external_bucket, :text
    add_column :gend_images, :image_external_key, :text
  end
end
