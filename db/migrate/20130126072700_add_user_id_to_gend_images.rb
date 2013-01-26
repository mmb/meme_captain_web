class AddUserIdToGendImages < ActiveRecord::Migration
  def change
    add_column :gend_images, :user_id, :integer
    add_index :gend_images, :user_id
  end
end
