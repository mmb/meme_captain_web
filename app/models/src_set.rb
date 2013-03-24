class SrcSet < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true
  validate :name, :one_active_name

  has_and_belongs_to_many :src_images
  belongs_to :user

  def one_active_name
    if new_record? && SrcSet.active.exists?(:name => name) or
        !is_deleted && SrcSet.count(
            :conditions => ['name = ? AND id != ? AND is_deleted = ?', name, id, false]) > 0
      errors.add :name, 'has already been taken'
    end
  end

  def add_src_images(add_id_hashes)
    to_add = SrcImage.find_all_by_id_hash(add_id_hashes) - self.src_images

    unless to_add.empty?
      self.src_images.concat(to_add)
      self.touch
    end
  end

  def delete_src_images(delete_id_hashes)
    to_delete = SrcImage.find_all_by_id_hash(delete_id_hashes)

    unless to_delete.empty?
      self.src_images.delete(*to_delete)
      self.touch
    end
  end

  def thumbnail
    recent = src_images.without_image.active.most_recent
    recent.first.src_thumb unless recent.empty?
  end

  def thumb_width
    thumb = thumbnail
    thumb.width if thumb
  end

  def thumb_height
    thumb = thumbnail
    thumb.height if thumb
  end

  def size_desc
    case src_images.count
      when 0..10 then
        :small
      when 11..50 then
        :medium
      else
        :large
    end
  end

  scope :active, where(:is_deleted => false)

  scope :owned_by, lambda { |user| where(:user_id => user.id) }

  scope :most_recent, lambda { |limit=1| order(:quality, :updated_at).reverse_order.limit(limit) }

  scope :front_page, where('quality >= 50')
end
