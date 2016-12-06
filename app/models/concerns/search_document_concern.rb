# ActiveRecord::Model mixin to combine text fields into a search document field.
module SearchDocumentConcern
  extend ActiveSupport::Concern

  included do
    before_create(:set_search_document)
    before_update(:set_search_document)
  end

  def set_search_document
    self.search_document = search_document_parts.join(' ')
                                                .gsub(/\s+/, ' ').strip
    true
  end
end
