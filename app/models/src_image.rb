class SrcImage < ActiveRecord::Base
  attr_accessible :image, :url

  validates :format, :height, :image, :size, :width, presence: true

  validates :id_hash, uniqueness: true

  belongs_to :user
  has_one :src_thumb

  before_create :set_id_hash

  before_validation :set_derived_image_fields

  protected

  def set_id_hash
    self.id_hash = gen_id_hash
  end

  def gen_id_hash
    begin
      id_hash = SecureRandom.urlsafe_base64(4)
    end while self.class.where(:id_hash => id_hash).exists?

    id_hash
  end

  def set_derived_image_fields
    if image
      img = Magick::Image.from_blob(image)[0]

      self.format = img.format
      self.height = img.rows
      self.size = image.size
      self.width = img.columns
    end
  end

end
