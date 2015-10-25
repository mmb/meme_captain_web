class AddExpiresAtToGendImages < ActiveRecord::Migration
  def change
    add_column :gend_images, :expires_at, :datetime
  end
end
