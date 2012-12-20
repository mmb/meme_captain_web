class AddContentTypeToGendImage < ActiveRecord::Migration
  def change
    add_column :gend_images, :content_type, :string
  end
end
