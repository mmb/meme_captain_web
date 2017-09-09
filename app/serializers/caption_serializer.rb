# frozen_string_literal: true

# JSON serializer for captions
class CaptionSerializer < ActiveModel::Serializer
  attributes :height_pct,
             :text,
             :top_left_x_pct,
             :top_left_y_pct,
             :width_pct
end
