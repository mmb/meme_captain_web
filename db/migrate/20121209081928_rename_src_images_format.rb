class RenameSrcImagesFormat < ActiveRecord::Migration
  def change
    rename_column :src_images, :format, :content_type
  end
end
