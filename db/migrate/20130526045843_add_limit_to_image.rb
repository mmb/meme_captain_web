class AddLimitToImage < ActiveRecord::Migration[5.0]

  def up
    change_column :gend_images, :image, :binary, limit: 16.megabytes
    change_column :gend_thumbs, :image, :binary, limit: 16.megabytes
    change_column :src_images, :image, :binary, limit: 16.megabytes
    change_column :src_thumbs, :image, :binary, limit: 16.megabytes
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'Reducing the limit of binary columns can cause data loss'
  end

end
