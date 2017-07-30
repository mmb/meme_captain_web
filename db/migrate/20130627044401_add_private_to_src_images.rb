class AddPrivateToSrcImages < ActiveRecord::Migration[5.0]

  def change
    add_column :src_images, :private, :boolean, default: false
    add_index :src_images, :private

    SrcImage.reset_column_information
    SrcImage.where('user_id IS NOT NULL').each do |si|
      si.update_attribute(:private, true)
    end
  end

end
