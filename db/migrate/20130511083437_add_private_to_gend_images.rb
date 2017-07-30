class AddPrivateToGendImages < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :private, :boolean, :default => false
    add_index :gend_images, :private

    GendImage.reset_column_information
    GendImage.where('user_id IS NOT NULL').each do |gi|
      gi.update_attribute(:private, true)
    end

  end
end
