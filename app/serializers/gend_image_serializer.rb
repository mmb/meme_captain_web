# JSON serializer for gend images
class GendImageSerializer < ActiveModel::Serializer
  attributes :image_url,
             :thumbnail_url

  has_many :captions
end
