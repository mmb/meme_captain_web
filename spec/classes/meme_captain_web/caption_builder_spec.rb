require 'rails_helper'

describe 'MemeCaptainWeb::CaptionBuilder' do
  describe '#build' do
    let(:caption_builder) { MemeCaptainWeb::CaptionBuilder.new }
    let(:gend_image) { FactoryGirl.create(:gend_image) }

    context 'when the src image has default captions' do
      before do
        gend_image.src_image.captions << FactoryGirl.create(:caption)
        gend_image.src_image.captions << FactoryGirl.create(:caption)
      end

      it "uses the src image's default captions" do
        caption_builder.build(gend_image)

        expect(gend_image.captions.size).to eq(2)

        caption1 = gend_image.captions[0]
        expect(caption1.top_left_x_pct).to eq(1.5)
        expect(caption1.top_left_y_pct).to eq(1.5)
        expect(caption1.width_pct).to eq(1.5)
        expect(caption1.height_pct).to eq(1.5)
        expect(caption1.text).to eq('MyString')
        expect(caption1.font).to be_nil

        caption2 = gend_image.captions[1]
        expect(caption2.top_left_x_pct).to eq(1.5)
        expect(caption2.top_left_y_pct).to eq(1.5)
        expect(caption2.width_pct).to eq(1.5)
        expect(caption2.height_pct).to eq(1.5)
        expect(caption2.text).to eq('MyString')
        expect(caption2.font).to be_nil
      end
    end

    context 'when the src image does not have default captions' do
      it 'uses the default captions' do
        caption_builder.build(gend_image)

        expect(gend_image.captions.size).to eq(2)

        caption1 = gend_image.captions[0]
        expect(caption1.top_left_x_pct).to eq(0.05)
        expect(caption1.top_left_y_pct).to eq(0)
        expect(caption1.width_pct).to eq(0.9)
        expect(caption1.height_pct).to eq(0.25)
        expect(caption1.text).to be_nil
        expect(caption1.font).to be_nil

        caption2 = gend_image.captions[1]
        expect(caption2.top_left_x_pct).to eq(0.05)
        expect(caption2.top_left_y_pct).to eq(0.75)
        expect(caption2.width_pct).to eq(0.9)
        expect(caption2.height_pct).to eq(0.25)
        expect(caption2.text).to be_nil
        expect(caption2.font).to be_nil
      end
    end
  end
end
