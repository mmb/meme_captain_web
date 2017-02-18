# ActiveRecord::Model mixin to set a random id hash column.
module IdHashConcern
  extend ActiveSupport::Concern

  included do
    before_create :set_id_hash
    validates :id_hash, uniqueness: true
  end

  def set_id_hash
    self.id_hash = gen_id_hash
  end

  def gen_id_hash
    id_hash = nil
    loop do
      id_hash = SecureRandom.urlsafe_base64(4)
      break unless self.class.where(id_hash: id_hash).exists?
    end

    id_hash
  end
end
