class TrigramIndices < ActiveRecord::Migration[5.0]
  def change
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute 'DROP INDEX IF EXISTS src_images_trgm_idx'
      execute "CREATE INDEX CONCURRENTLY src_images_trgm_idx ON src_images USING gin(search_document gin_trgm_ops);"

      execute 'DROP INDEX IF EXISTS gend_images_trgm_idx'
      execute "CREATE INDEX CONCURRENTLY gend_images_trgm_idx ON gend_images USING gin(search_document gin_trgm_ops);"

      execute 'DROP INDEX IF EXISTS src_sets_trgm_idx'
      execute "CREATE INDEX CONCURRENTLY src_sets_trgm_idx ON src_sets USING gin(search_document gin_trgm_ops);"
    end
  end
end
