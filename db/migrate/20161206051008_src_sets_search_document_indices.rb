class SrcSetsSearchDocumentIndices < ActiveRecord::Migration[5.0]
  def change
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute 'drop index if exists src_sets_to_tsvector_idx'
      execute "create index on src_sets using gin(to_tsvector('english', search_document));"
    end
  end
end
