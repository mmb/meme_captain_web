class AddGendImagesCountToSrcImages < ActiveRecord::Migration[4.2]

  def up
    add_column :src_images, :gend_images_count, :integer, null: false, default: 0
    add_index :src_images, :gend_images_count

    SrcImage.reset_column_information

    SrcImage.find_each do |si|
      SrcImage.reset_counters(si.id, :gend_images)
    end
  end

  def down
    remove_column :src_images, :gend_images_count
  end

end
