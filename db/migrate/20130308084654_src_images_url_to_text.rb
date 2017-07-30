class SrcImagesUrlToText < ActiveRecord::Migration[4.2]

  def change
    change_column :src_images, :url, :text, :limit => nil
  end

end
