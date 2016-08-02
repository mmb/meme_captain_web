# JSON serializer for src images
class SrcImageSerializer < ActiveModel::Serializer
  attributes :content_type,
             :created_at,
             :height,
             :id_hash,
             :image_url,
             :name,
             :size,
             :updated_at,
             :width
end
