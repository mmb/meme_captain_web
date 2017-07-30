class AddSearchDocument < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :search_document, :text
    add_column :src_images, :search_document, :text
    add_column :src_sets, :search_document, :text
  end
end
