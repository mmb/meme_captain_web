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
    begin
      id_hash = SecureRandom.urlsafe_base64(4)
    end while self.class.where(:id_hash => id_hash).exists?

    id_hash
  end

end
