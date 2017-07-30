class AddContentTypeToGendImage < ActiveRecord::Migration[4.2]
  def change
    add_column :gend_images, :content_type, :string
  end
end
