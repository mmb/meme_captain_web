class AddErrorToSrcImages < ActiveRecord::Migration[4.2]
  def change
    add_column :src_images, :error, :text
    add_index :src_images, :error, length: 64
  end
end
