class RenameSrcThumbsFormat < ActiveRecord::Migration[5.0]
  def change
    rename_column :src_thumbs, :format, :content_type
  end
end
