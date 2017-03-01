class CreateSrcImagesCaptions < ActiveRecord::Migration[5.0]
  def change
    create_table :src_images_captions do |t|
      t.references :src_image, foreign_key: true
      t.references :caption, foreign_key: true
    end
  end
end
