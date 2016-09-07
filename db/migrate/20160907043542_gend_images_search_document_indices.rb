class GendImagesSearchDocumentIndices < ActiveRecord::Migration
  def change
    add_index :gend_images, :search_document, length: 64

    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute "create index on gend_images using gin(to_tsvector('english', search_document));"
    end
  end
end
