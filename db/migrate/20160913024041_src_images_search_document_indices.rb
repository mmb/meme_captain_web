class SrcImagesSearchDocumentIndices < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute 'drop index src_images_to_tsvector_idx'
      execute "create index on src_images using gin(to_tsvector('english', search_document));"
    end
  end
end
