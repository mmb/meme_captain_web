class AddIndexToIdHash < ActiveRecord::Migration[5.0]

  def change
    add_index :gend_images, :id_hash, unique: true
    add_index :src_images, :id_hash, unique: true
  end

end
