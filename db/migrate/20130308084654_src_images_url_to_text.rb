class SrcImagesUrlToText < ActiveRecord::Migration

  def change
    change_column :src_images, :url, :text, :limit => nil
  end

end
