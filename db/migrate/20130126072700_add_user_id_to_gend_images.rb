class AddUserIdToGendImages < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :user_id, :integer
    add_index :gend_images, :user_id
  end
end
