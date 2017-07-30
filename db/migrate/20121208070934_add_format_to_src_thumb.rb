class AddFormatToSrcThumb < ActiveRecord::Migration[5.0]
  def change
    add_column :src_thumbs, :format, :string
  end
end
