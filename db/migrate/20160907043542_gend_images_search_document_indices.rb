class GendImagesSearchDocumentIndices < ActiveRecord::Migration[4.2]
  def change
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute "create index on gend_images using gin(to_tsvector('english', search_document));"
    end
  end
end
