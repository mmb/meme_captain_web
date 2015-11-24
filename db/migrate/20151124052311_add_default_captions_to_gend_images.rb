class AddDefaultCaptionsToGendImages < ActiveRecord::Migration
  def change
    add_column :gend_images, :default_captions, :boolean, default: false

    add_index :gend_images, [:src_image_id, :default_captions],
      order: { src_image_id: :asc, default_captions: :desc }
  end
end
