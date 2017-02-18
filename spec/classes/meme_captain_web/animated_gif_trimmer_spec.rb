require 'rails_helper'

require 'support/fixture_file'

describe MemeCaptainWeb::AnimatedGifTrimmer do
  subject(:animated_gif_trimmer) { MemeCaptainWeb::AnimatedGifTrimmer.new }

  describe '#trim' do
    let(:image_data) { File.open(image_path, 'rb', &:read) }

    context 'when the image is a typical animated gif' do
      let(:image_path) { fixture_file('omgcat_unoptimized.gif') }

      it 'deletes every other frame of the image' do
        trimmed_data = MemeCaptainWeb::AnimatedGifTrimmer.new.trim(image_data)
        trimmed_img = Magick::ImageList.new.from_blob(trimmed_data)
        expect(trimmed_img.size).to eq(25)
      end
    end

    context 'when the image has graphics control extension, application ' \
      'extension' do
      let(:image_path) { fixture_file('omgcat_ga.gif') }

      it 'deletes every other frame of the image' do
        trimmed_data = MemeCaptainWeb::AnimatedGifTrimmer.new.trim(image_data)
        trimmed_img = Magick::ImageList.new.from_blob(trimmed_data)
        expect(trimmed_img.size).to eq(25)
      end
    end

    context 'when the image contains graphics control extension, comment ' \
      'extension, application extension' do
      let(:image_path) { fixture_file('omgcat_gca.gif') }

      it 'deletes every other frame of the image' do
        trimmed_data = MemeCaptainWeb::AnimatedGifTrimmer.new.trim(image_data)
        trimmed_img = Magick::ImageList.new.from_blob(trimmed_data)
        expect(trimmed_img.size).to eq(25)
      end
    end

    context 'when the image contains application extension, graphics control ' \
      'extension' do
      let(:image_path) { fixture_file('omgcat_ag.gif') }

      it 'deletes every other frame of the image' do
        trimmed_data = MemeCaptainWeb::AnimatedGifTrimmer.new.trim(image_data)
        trimmed_img = Magick::ImageList.new.from_blob(trimmed_data)
        expect(trimmed_img.size).to eq(25)
      end
    end
  end
end
