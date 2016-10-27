# URL validator.
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Addressable::URI.parse(value)
  rescue StandardError => e
    record.errors[attribute] << e.to_s
  end
end
