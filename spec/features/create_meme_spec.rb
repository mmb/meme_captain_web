require 'rails_helper'

require 'support/features'

RSpec.feature 'create meme', type: :feature, js: true do
  scenario 'create meme' do
    create_user

    create_src_image

    click_button('Add another caption')

    fill_in('Caption 1', with: 'caption 1')
    fill_in('Caption 3', with: 'caption 2')
    fill_in('Caption 3', with: 'caption 3')

    click_button('Create')

    expect(page).to have_text('Submitted request')
    expect(page).to have_current_path(%r{/gend_image_pages/.+}, wait: 10)
  end
end
