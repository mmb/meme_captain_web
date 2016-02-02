# encoding: UTF-8
# frozen_string_literal: true

# A caption is a box of text in a meme.
class Caption < ActiveRecord::Base
  belongs_to :gend_image

  validates :height_pct, presence: true
  validates :text, presence: true
  validates :top_left_x_pct, presence: true
  validates :top_left_y_pct, presence: true
  validates :width_pct, presence: true

  before_save :default_values

  def default_values
    self.font = MemeCaptainWeb::Font.for(text) if font.blank?
  end

  def font_path
    "#{Rails.root}/fonts/#{font}"
  end

  def text_pos
    MemeCaptain::TextPos.new(
      text_processed, top_left_x_pct, top_left_y_pct, width_pct, height_pct,
      font: font_path)
  end

  private

  def text_processed
    bidi = TwitterCldr::Shared::Bidi.from_string(text.mb_chars.upcase)
    bidi.reorder_visually!
    bidi.to_s
  end

  scope :position_order, -> { reorder('top_left_y_pct, top_left_x_pct'.freeze) }
end
