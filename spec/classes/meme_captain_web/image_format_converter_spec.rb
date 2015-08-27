require 'rails_helper'

describe 'MemeCaptainWeb::ImageFormatConverter' do
  subject(:image_format_converter) { MemeCaptainWeb::ImageFormatConverter.new }

  describe '#convert' do
    let(:image) { double(Magick::ImageList) }
    before do
      allow(image).to receive(:format).and_return(format)
    end

    context 'when the image format is SVG' do
      let(:format) { 'SVG' }

      it 'changes the format to PNG' do
        expect(image).to receive(:format=).with('PNG')
        image_format_converter.convert(image)
      end
    end

    context 'when the image format does not need to be converted' do
      let(:format) { 'GIF' }

      it 'does not change the format' do
        expect(image).to_not receive(:format=).with('PNG')
        image_format_converter.convert(image)
      end
    end
  end
end
