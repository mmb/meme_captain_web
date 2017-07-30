class RemoveUserIdFromGendImage < ActiveRecord::Migration[4.2]
  def up
    remove_column :gend_images, :user_id
  end

  def down
    add_column :gend_images, :user_id, :integer
  end
end
