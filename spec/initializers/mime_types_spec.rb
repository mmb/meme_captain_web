require 'rails_helper'

describe 'mime types' do
  it 'registers the webp mime type' do
    expect(Mime::Type.lookup('image/webp').symbol).to eq(:webp)
  end
end
