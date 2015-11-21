# encoding: UTF-8

# Source image set model.
class SrcSet < ActiveRecord::Base
  validates :name, presence: true
  validate :name, :one_active_name

  has_and_belongs_to_many :src_images, join_table: :src_images_src_sets

  belongs_to :user

  def one_active_name
    # rubocop:disable Style/GuardClause
    if new_record? && name_taken? ||
       !is_deleted && name_taken_by_other?
      errors.add(:name, 'has already been taken'.freeze)
    end
    # rubocop:enable Style/GuardClause
  end

  def add_src_images(add_id_hashes)
    to_add = SrcImage.where(id_hash: add_id_hashes) - src_images
    return if to_add.empty?

    src_images.concat(to_add)
    touch
  end

  def delete_src_images(delete_id_hashes)
    to_delete = SrcImage.where(id_hash: delete_id_hashes)
    return if to_delete.empty?

    src_images.delete(*to_delete)
    touch
  end

  def thumbnail
    Rails.cache.fetch("#{cache_key}/thumbnail") do
      recent = src_images.without_image.active.most_used
      recent.first.src_thumb unless recent.empty?
    end
  end

  def thumb_width
    thumb = thumbnail
    thumb.width if thumb
  end

  def thumb_height
    thumb = thumbnail
    thumb.height if thumb
  end

  scope :active, -> { where is_deleted: false }

  scope :owned_by, ->(user) { where user_id: user.id }

  scope :most_recent, lambda { |limit = 1|
    order(:quality, :updated_at).reverse_order.limit(limit)
  }

  scope :front_page, lambda {
    where('quality >= ?'.freeze, MemeCaptainWeb::Config::SetFrontPageMinQuality)
  }

  scope :not_empty, lambda {
    joins(:src_images).where(
      'src_images.is_deleted'.freeze => false).group('src_sets.id'.freeze)
  }

  scope :name_matches, lambda { |query|
    where('LOWER(src_sets.name) LIKE ?'.freeze, "%#{query.downcase}%") if query
  }

  private

  def name_taken?
    SrcSet.active.exists?(name: name)
  end

  def name_taken_by_other?
    SrcSet.where('name = ? AND id != ?'.freeze, name, id).active.exists?
  end
end
