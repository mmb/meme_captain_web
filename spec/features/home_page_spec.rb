require 'rails_helper'

RSpec.feature 'home page', type: :feature do
  let(:user) { FactoryGirl.create(:user, password: 'secret') }

  before do
    src_image = FactoryGirl.create(:src_image)
    src_image.run_callbacks(:commit)
    gend_image = FactoryGirl.create(:gend_image, src_image: src_image)
    gend_image.run_callbacks(:commit)
    Delayed::Worker.new(exit_on_complete: true).start
  end

  def login
    visit('/session/new')
    fill_in('email', with: user.email)
    fill_in('password', with: 'secret')
    click_button('Login')
  end

  scenario 'ssl' do
    page.driver.header('X-Forwarded-Proto', 'https')

    login
    visit('/')

    expect(page).to_not have_selector('img[src^="http:"]')
    expect(page).to_not have_selector('link[src^="http:"]')
  end
end
