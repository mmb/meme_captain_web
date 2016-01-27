require 'rails_helper'

describe MemeCaptainWeb::AnimatedGifTrimmer do
  subject(:animated_gif_trimmer) { MemeCaptainWeb::AnimatedGifTrimmer.new }

  describe '#trim' do
    let(:image_data) { File.open(image_path, 'rb', &:read) }

    context 'when the image is a typical animated gif' do
      let(:image_path) do
        Rails.root + 'spec/fixtures/files/omgcat_unoptimized.gif'
      end

      it 'deletes every other frame of the image' do
        trimmed_data = MemeCaptainWeb::AnimatedGifTrimmer.new.trim(image_data)
        trimmed_img = Magick::ImageList.new.from_blob(trimmed_data)
        expect(trimmed_img.size).to eq(25)
      end
    end

    context 'when the image has graphics control extension, application ' \
      'extension' do
      let(:image_path) do
        Rails.root + 'spec/fixtures/files/omgcat_ga.gif'
      end

      it 'deletes every other frame of the image' do
        trimmed_data = MemeCaptainWeb::AnimatedGifTrimmer.new.trim(image_data)
        trimmed_img = Magick::ImageList.new.from_blob(trimmed_data)
        expect(trimmed_img.size).to eq(25)
      end
    end

    context 'when the image contains graphics control extension, comment ' \
      'extension, application extension' do
      let(:image_path) do
        Rails.root + 'spec/fixtures/files/omgcat_gca.gif'
      end

      it 'deletes every other frame of the image' do
        trimmed_data = MemeCaptainWeb::AnimatedGifTrimmer.new.trim(image_data)
        trimmed_img = Magick::ImageList.new.from_blob(trimmed_data)
        expect(trimmed_img.size).to eq(25)
      end
    end

    context 'when the image contains application extension, graphics control ' \
      'extension' do
      let(:image_path) do
        Rails.root + 'spec/fixtures/files/omgcat_ag.gif'
      end

      it 'deletes every other frame of the image' do
        trimmed_data = MemeCaptainWeb::AnimatedGifTrimmer.new.trim(image_data)
        trimmed_img = Magick::ImageList.new.from_blob(trimmed_data)
        expect(trimmed_img.size).to eq(25)
      end
    end
  end
end
