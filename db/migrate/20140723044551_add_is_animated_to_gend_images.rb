class AddIsAnimatedToGendImages < ActiveRecord::Migration[4.2]
  def change
    add_column :gend_images, :is_animated, :boolean, default: false
    add_index :gend_images, :is_animated
  end
end
