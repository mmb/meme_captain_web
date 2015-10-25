class AddExpiresAtToSrcImages < ActiveRecord::Migration
  def change
    add_column :src_images, :expires_at, :datetime
  end
end
