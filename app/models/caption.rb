# encoding: UTF-8

# A caption is a box of text in a meme.
class Caption < ActiveRecord::Base
  belongs_to :gend_image

  validates :text, presence: true

  before_save :default_values

  def default_values
    self.font = MemeCaptainWeb::Font.for(text) if font.blank?
  end

  def font_path
    "#{Rails.root}/fonts/#{font}"
  end

  def text_pos
    MemeCaptain::TextPos.new(text, top_left_x_pct, top_left_y_pct, width_pct,
                             height_pct, font: font_path)
  end

  private

  scope :position_order, -> { reorder('top_left_y_pct, top_left_x_pct') }
end
