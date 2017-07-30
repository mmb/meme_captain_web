class AddExpiresAtToGendImages < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :expires_at, :datetime
  end
end
