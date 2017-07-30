class AddContentTypeToGendImage < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :content_type, :string
  end
end
