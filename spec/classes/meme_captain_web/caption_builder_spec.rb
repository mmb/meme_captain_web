require 'rails_helper'

describe 'MemeCaptainWeb::CaptionBuilder' do
  describe '#build' do
    it 'builds the captions' do
      caption_builder = MemeCaptainWeb::CaptionBuilder.new
      gend_image = instance_double(GendImage)
      captions = instance_double(
        Caption::ActiveRecord_Associations_CollectionProxy
      )
      expect(gend_image).to receive(:captions).twice.and_return(captions)

      expect(captions).to receive(:build).with(
        top_left_x_pct: 0.05,
        top_left_y_pct: 0,
        width_pct: 0.9,
        height_pct: 0.25
      )
      expect(captions).to receive(:build).with(
        top_left_x_pct: 0.05,
        top_left_y_pct: 0.75,
        width_pct: 0.9,
        height_pct: 0.25
      )

      caption_builder.build(gend_image)
    end
  end
end
