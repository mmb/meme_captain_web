require 'rails_helper'

RSpec.feature 'instance health', type: :feature do
  scenario 'instance health' do
    visit('/instance_health')

    expect(page.status_code).to be(200)
    expect(page).to have_text('ok')
  end
end
