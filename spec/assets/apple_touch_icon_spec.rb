require 'rails_helper'

describe 'apple-touch-icon.png' do
  it 'is an asset' do
    expect(
      Rails.application.assets.find_asset('apple-touch-icon.png')
    )
      .to_not be_nil
  end
end
