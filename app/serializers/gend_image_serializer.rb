# JSON serializer for gend images
class GendImageSerializer < ActiveModel::Serializer
  attributes :content_type,
             :created_at,
             :height,
             :image_url,
             :size,
             :thumbnail_url,
             :updated_at,
             :width

  has_many :captions
end
