class AddErrorToGendImages < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :error, :text
    add_index :gend_images, :error, length: 64
  end
end
