class CreateSrcImages < ActiveRecord::Migration[4.2]
  def change
    create_table :src_images do |t|
      t.string :id_hash
      t.string :url
      t.integer :width
      t.integer :height
      t.integer :size
      t.string :format
      t.binary :image
      t.references :src_thumb
      t.references :user

      t.timestamps
    end
  end
end
