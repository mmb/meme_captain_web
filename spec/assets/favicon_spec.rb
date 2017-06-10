require 'rails_helper'

describe 'favicon.ico' do
  it 'is an asset' do
    expect(
      Rails.application.assets.find_asset('favicon.ico')
    )
      .to_not be_nil
  end
end
