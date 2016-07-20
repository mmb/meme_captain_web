require 'rails_helper'

describe 'apple-touch-icon.png' do
  it 'is an asset' do
    expect(
      Rails.application.assets.find_asset('apple-touch-icon.png')
    )
      .not_to be_nil
  end
end
