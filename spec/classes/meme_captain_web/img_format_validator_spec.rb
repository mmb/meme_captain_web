require 'rails_helper'

describe MemeCaptainWeb::ImgFormatValidator do
  subject(:img_format_validator) { MemeCaptainWeb::ImgFormatValidator.new }

  let(:image_data) do
    open(Rails.root + 'spec/fixtures/files' + image, 'rb', &:read)
  end

  describe '#valid?' do
    context 'when the image is a bitmap' do
      let(:image) { 'ti_duck.bmp' }

      it 'is valid' do
        expect(img_format_validator.valid?(image_data)).to be(true)
      end
    end

    context 'when the image is a gif' do
      let(:image) { 'omgcat.gif' }

      it 'is valid' do
        expect(img_format_validator.valid?(image_data)).to be(true)
      end
    end

    context 'when the image is a jpeg' do
      let(:image) { 'ti_duck.jpg' }

      it 'is valid' do
        expect(img_format_validator.valid?(image_data)).to be(true)
      end
    end

    context 'when the image is a png' do
      let(:image) { 'ti_duck.png' }

      it 'is valid' do
        expect(img_format_validator.valid?(image_data)).to be(true)
      end
    end

    context 'when the image is an svg' do
      let(:image) { 'thumbs_up.svg' }

      it 'is valid' do
        expect(img_format_validator.valid?(image_data)).to be(true)
      end
    end

    context 'when the image is a webp' do
      let(:image) { 'ti_duck.webp' }

      it 'is valid' do
        expect(img_format_validator.valid?(image_data)).to be(true)
      end
    end

    context 'when the image is not an image' do
      let(:image_data) { 'i am not an image' }

      it 'is valid' do
        expect(img_format_validator.valid?(image_data)).to be(false)
      end
    end

    context 'when the image data encoding is UTF-8' do
      let(:image) { 'ti_duck.jpg' }

      it 'is valid' do
        image_data.force_encoding('UTF-8')
        expect(img_format_validator.valid?(image_data)).to be(true)
      end
    end
  end
end
