# encoding: UTF-8

# Source image model.
class SrcImage < ActiveRecord::Base
  include HasImageConcern
  include IdHashConcern

  belongs_to :user
  has_one :src_thumb
  has_many :gend_images
  has_and_belongs_to_many :src_sets, join_table: :src_images_src_sets

  before_validation :add_url_scheme

  validate :image_if_not_url

  after_commit :create_jobs, on: :create

  attr_accessor :image_url

  def image_if_not_url
    # rubocop:disable Style/GuardClause
    if url.blank? && image.blank?
      errors.add :image, 'is required if url is not set.'.freeze
    end
    # rubocop:enable Style/GuardClause
  end

  def load_from_url
    return unless url
    self.image = MemeCaptainWeb::ImgUrlComposer.new.load(url)
  end

  def create_jobs
    SrcImageProcessJob.new(id).delay(queue: queue).perform
  end

  # rubocop:disable MethodLength
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
  # rubocop:enable MethodLength

  def self.for_user(user, query, page)
    if user.try(:is_admin)
      without_image.includes(:src_thumb).name_matches(query)
        .most_used.page(page)
    else
      without_image.includes(:src_thumb).name_matches(query)
        .publick.active.finished.most_used.page(page)
    end
  end

  protected

  scope :active, -> { where is_deleted: false }

  scope :owned_by, ->(user) { where user_id: user.id }

  scope :most_recent, lambda { |limit = 1|
    order(:updated_at).reverse_order.limit(limit)
  }

  scope :publick, -> { where private: false }

  scope :name_matches, lambda { |query|
    where('LOWER(name) LIKE ?'.freeze, "%#{query.downcase}%") if query
  }

  scope :most_used, lambda { |limit = 1|
    order(:gend_images_count).reverse_order.limit(limit)
  }

  scope :finished, -> { where work_in_progress: false }

  private

  def add_url_scheme
    return true if url.blank?
    return true if url.start_with?('http://'.freeze, 'https://'.freeze)
    self.url = "http://#{url}"
    true
  end

  def queue
    url? ? :src_image_process_url : :src_image_process
  end
end
