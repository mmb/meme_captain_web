class AddErrorToGendImages < ActiveRecord::Migration[4.2]
  def change
    add_column :gend_images, :error, :text
    add_index :gend_images, :error, length: 64
  end
end
