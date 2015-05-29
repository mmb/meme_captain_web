# encoding: UTF-8

require 'rails_helper'

describe '#content_type' do
  subject(:image_list) { Magick::ImageList.new }

  before do
    first_image = instance_double(Magick::Image)
    allow(image_list).to receive(:first).and_return(first_image)
    allow(first_image).to receive(:format).and_return(format)
  end

  context 'when the image format is GIF' do
    let(:format) { 'GIF' }
    it 'return image/gif for the content type' do
      expect(image_list.content_type).to eq('image/gif')
    end
  end

  context 'when the image format is JPEG' do
    let(:format) { 'JPEG' }
    it 'return image/jpeg for the content type' do
      expect(image_list.content_type).to eq('image/jpeg')
    end
  end

  context 'when the image format is PNG' do
    let(:format) { 'PNG' }
    it 'return image/png for the content type' do
      expect(image_list.content_type).to eq('image/png')
    end
  end

  context 'when the image format is BMP' do
    let(:format) { 'BMP' }
    it 'return image/bmp for the content type' do
      expect(image_list.content_type).to eq('image/bmp')
    end
  end

  context 'when the image format is BMP2' do
    let(:format) { 'BMP2' }
    it 'return image/bmp for the content type' do
      expect(image_list.content_type).to eq('image/bmp')
    end
  end

  context 'when the image format is BMP3' do
    let(:format) { 'BMP3' }
    it 'return image/bmp for the content type' do
      expect(image_list.content_type).to eq('image/bmp')
    end
  end
end
