class AddExpiresAtToGendImages < ActiveRecord::Migration[4.2]
  def change
    add_column :gend_images, :expires_at, :datetime
  end
end
