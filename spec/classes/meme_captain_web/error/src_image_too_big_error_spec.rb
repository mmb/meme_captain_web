require 'rails_helper'

describe MemeCaptainWeb::Error::SrcImageTooBigError do
  context 'when the size is nil' do
    let(:size) { nil }
    it 'returns the image size in the message' do
      expect do
        raise(MemeCaptainWeb::Error::SrcImageTooBigError)
      end.to raise_error(
        MemeCaptainWeb::Error::SrcImageTooBigError, 'image is too large'
      )
    end
  end

  context 'when the size is not nil' do
    let(:size) { 123_456_789 }

    it 'returns the image size in the message' do
      expect do
        raise(MemeCaptainWeb::Error::SrcImageTooBigError, size)
      end.to raise_error(
        MemeCaptainWeb::Error::SrcImageTooBigError,
        'image is too large (118 MB)'
      )
    end
  end
end
