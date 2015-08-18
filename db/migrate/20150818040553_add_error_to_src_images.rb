class AddErrorToSrcImages < ActiveRecord::Migration
  def change
    add_column :src_images, :error, :text
    add_index :src_images, :error, length: 64
  end
end
