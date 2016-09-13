namespace :search_document do
  desc 'Populate gend image search documents that are empty'
  task populate_gend_image: :environment do
    GendImage.where(search_document: nil).without_image.find_each(
      batch_size: 100
    ) do |gi|
      parts = gi.captions.sort do |a, b|
        if a.top_left_y_pct && !a.top_left_y_pct.nan? &&
           a.top_left_x_pct && !a.top_left_x_pct.nan? &&
           b.top_left_y_pct && !b.top_left_y_pct.nan? &&
           b.top_left_x_pct && !b.top_left_x_pct.nan?
          [a.top_left_y_pct, a.top_left_x_pct] <=> \
            [b.top_left_y_pct, b.top_left_x_pct]
        else
          a.id <=> b.id
        end
      end.map(&:text)
      parts << gi.src_image.name
      parts << gi.id_hash

      search_document = parts.join(' ').strip
      gi.update_column(:search_document, search_document)
    end
  end

  desc 'Populate src image search documents that are empty'
  task populate_src_image: :environment do
    SrcImage.where(search_document: nil).without_image.find_each(
      batch_size: 100
    ) do |si|
      parts = [si.name, si.id_hash]
      search_document = parts.join(' ').strip
      si.update_column(:search_document, search_document)
    end
  end
end
