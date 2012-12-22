class CreateGendThumbs < ActiveRecord::Migration
  def change
    create_table :gend_thumbs do |t|
      t.string :content_type
      t.references :gend_image
      t.integer :height
      t.binary :image
      t.integer :size
      t.integer :width

      t.timestamps
    end
    add_index :gend_thumbs, :gend_image_id
  end
end
