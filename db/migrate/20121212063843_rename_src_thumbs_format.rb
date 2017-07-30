class RenameSrcThumbsFormat < ActiveRecord::Migration[4.2]
  def change
    rename_column :src_thumbs, :format, :content_type
  end
end
