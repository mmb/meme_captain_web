class CreateSrcSetJoinTable < ActiveRecord::Migration[4.2]
  def change
    create_table :src_images_src_sets, :id => false do |t|
      t.references :src_image
      t.references :src_set
    end
    add_index :src_images_src_sets, [:src_image_id, :src_set_id],
      :unique => true
  end
end
