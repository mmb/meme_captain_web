class RenameSrcThumbsFormat < ActiveRecord::Migration
  def change
    rename_column :src_thumbs, :format, :content_type
  end
end
