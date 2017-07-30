class RenameSrcImagesFormat < ActiveRecord::Migration[5.0]
  def change
    rename_column :src_images, :format, :content_type
  end
end
