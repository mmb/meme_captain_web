require 'rails_helper'

require 'support/fixture_file'

describe MemeCaptainWeb::ImgBlobLoader do
  subject(:img_blob_loader) do
    MemeCaptainWeb::ImgBlobLoader.new(validator: validator)
  end

  let(:validator) { instance_double('MemeCaptainWeb::ImgFormatValidator') }
  let(:img_data) { fixture_file_data('ti_duck.jpg') }

  before do
    allow(validator).to receive(:valid?).with(img_data).and_return(valid)
  end

  describe '#load_blob' do
    context 'when the image data is valid' do
      let(:valid) { true }

      it 'returns a Magick::Image' do
        img = img_blob_loader.load_blob(img_data)
        expect(img).to be_a(Magick::ImageList)
        expect(img.columns).to eq(399)
        expect(img.rows).to eq(399)
      end
    end

    context 'when the image data is invalid' do
      let(:valid) { false }

      it 'raises an exception' do
        expect do
          img_blob_loader.load_blob(img_data)
        end.to raise_error(
          MemeCaptainWeb::Error::UnsupportedImageFormatError,
          'unsupported image format'
        )
      end
    end
  end
end
