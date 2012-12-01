class CreateGendImages < ActiveRecord::Migration
  def change
    create_table :gend_images do |t|
      t.string :id_hash
      t.references :src_image
      t.references :user

      t.timestamps
    end
  end
end
