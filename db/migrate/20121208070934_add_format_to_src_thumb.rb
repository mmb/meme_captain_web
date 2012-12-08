class AddFormatToSrcThumb < ActiveRecord::Migration
  def change
    add_column :src_thumbs, :format, :string
  end
end
