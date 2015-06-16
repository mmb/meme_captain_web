# encoding: UTF-8

# Source image model.
class SrcImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern

  belongs_to :user
  has_one :src_thumb
  has_many :gend_images
  has_and_belongs_to_many :src_sets, join_table: :src_images_src_sets

  validate :image_if_not_url

  after_commit :create_jobs

  attr_accessor :image_url

  def image_if_not_url
    # rubocop:disable Style/GuardClause
    if url.blank? && image.blank?
      errors.add :image, 'is required if url is not set.'
    end
    # rubocop:enable Style/GuardClause
  end

  def load_from_url
    return unless url
    self.image = MemeCaptainWeb::ImgUrlComposer.new.load(url)
    set_derived_image_fields
  end

  def create_jobs
    SrcImageProcessJob.perform_later(self) if work_in_progress
  end

  def as_json(_options = nil)
    super(only: [
      :id_hash,
      :width,
      :height,
      :size,
      :content_type,
      :created_at,
      :updated_at,
      :name
    ], methods: [
      :image_url
    ])
  end

  protected

  scope :active, -> { where is_deleted: false }

  scope :owned_by, ->(user) { where user_id: user.id }

  scope :most_recent, lambda { |limit = 1|
    order(:updated_at).reverse_order.limit(limit)
  }

  scope :publick, -> { where private: false }

  scope :name_matches, lambda { |query|
    where('LOWER(name) LIKE ?', "%#{query.downcase}%") if query
  }

  scope :most_used, lambda { |limit = 1|
    order(:gend_images_count).reverse_order.limit(limit)
  }

  scope :finished, -> { where work_in_progress: false }
end
