class AddExpiresAtToSrcImages < ActiveRecord::Migration[4.2]
  def change
    add_column :src_images, :expires_at, :datetime
  end
end
