class PopulateGendImagesSearchDocument < ActiveRecord::Migration
  class GendImagePopulateSearchDocument < ActiveRecord::Base
    self.table_name = 'gend_images'

    belongs_to :src_image
    has_many :captions, foreign_key: :gend_image_id

    scope :without_image, lambda {
      select((column_names - ['image'.freeze]).map { |c| "#{table_name}.#{c}" })
    }

    def build_search_document
      parts = captions.sort_by do |c|
        [c.top_left_y_pct, c.top_left_x_pct]
      end.map(&:text)
      parts << src_image.name
      parts << id_hash

      parts.join(' ').strip
    end
  end

  def up
    GendImagePopulateSearchDocument.where(
      search_document: nil).without_image.find_each(batch_size: 100) do |gi|
      gi.update_column(:search_document, gi.build_search_document)
    end
  end
end
