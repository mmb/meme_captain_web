class AddExpiresAtToSrcImages < ActiveRecord::Migration[5.0]
  def change
    add_column :src_images, :expires_at, :datetime
  end
end
