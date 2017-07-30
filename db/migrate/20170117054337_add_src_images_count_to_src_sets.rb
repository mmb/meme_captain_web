class AddSrcImagesCountToSrcSets < ActiveRecord::Migration[5.0]
  def change
    add_column :src_sets, :src_images_count, :integer, null: false, default: 0
    add_index :src_sets, :src_images_count
  end
end
