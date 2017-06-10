require 'rails_helper'

describe CaptionSerializer do
  describe 'attributes' do
    it 'serializes the correct attributes' do
      expect(CaptionSerializer._attributes).to eq(
        %i[
          height_pct
          text
          top_left_x_pct
          top_left_y_pct
          width_pct
        ]
      )
    end
  end
end
