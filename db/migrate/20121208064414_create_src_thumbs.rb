class CreateSrcThumbs < ActiveRecord::Migration
  def change
    create_table :src_thumbs do |t|
      t.references :src_image
      t.integer :width
      t.integer :height
      t.integer :size
      t.binary :image

      t.timestamps
    end
  end
end
