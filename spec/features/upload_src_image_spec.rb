require 'rails_helper'

require 'support/features'

RSpec.feature 'upload src image', type: :feature do
  scenario 'upload src image' do
    create_user

    click_on('New')

    attach_file('src_image_image',
                Rails.root + 'spec/fixtures/files/ti_duck.jpg')

    click_button('Create')

    expect(page).to have_text('Source image created.')
  end
end
