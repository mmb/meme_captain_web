class SrcImagesUrlToText < ActiveRecord::Migration[5.0]

  def change
    change_column :src_images, :url, :text, :limit => nil
  end

end
