class AddFormatToSrcThumb < ActiveRecord::Migration[4.2]
  def change
    add_column :src_thumbs, :format, :string
  end
end
