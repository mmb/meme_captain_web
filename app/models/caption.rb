class Caption < ActiveRecord::Base
  belongs_to :gend_image

  attr_accessible :font, :height_pct, :text, :top_left_x_pct, :top_left_y_pct, :width_pct

  validates :text, presence: true
end
