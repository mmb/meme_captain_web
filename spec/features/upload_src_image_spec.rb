require 'rails_helper'

require 'support/features'
require 'support/fixture_file'

RSpec.feature 'upload src image', type: :feature do
  scenario 'upload src image' do
    create_user

    click_on('New')

    attach_file('src_image_image', fixture_file('ti_duck.jpg'))

    click_button('Create')

    expect(page).to have_text('Source image created.')
  end
end
