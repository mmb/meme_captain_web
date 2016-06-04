class SrcImageNameFullTextIndex < ActiveRecord::Migration
  def change
    return unless ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'

    # replace with add_index, see https://github.com/rails/rails/issues/25270
    execute "create index on src_images using gin(to_tsvector('english', name));"
  end
end
