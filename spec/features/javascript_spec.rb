require 'rails_helper'

RSpec.feature 'javascript', type: :feature, js: true do
  it 'has no javascript errors' do
    visit('/')
    expect(page.driver.error_messages).to be_empty
  end
end
