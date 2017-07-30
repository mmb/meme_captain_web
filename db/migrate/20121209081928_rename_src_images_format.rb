class RenameSrcImagesFormat < ActiveRecord::Migration[4.2]
  def change
    rename_column :src_images, :format, :content_type
  end
end
