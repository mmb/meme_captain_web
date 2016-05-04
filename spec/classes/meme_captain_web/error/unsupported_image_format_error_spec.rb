require 'rails_helper'

describe MemeCaptainWeb::Error::UnsupportedImageFormatError do
  it 'acts like an error' do
    expect do
      raise MemeCaptainWeb::Error::UnsupportedImageFormatError
    end.to raise_error(
      MemeCaptainWeb::Error::UnsupportedImageFormatError,
      'unsupported image format')
  end
end
