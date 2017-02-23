require 'rails_helper'

require 'support/features'

RSpec.feature 'delete source set', type: :feature, js: true do
  scenario 'create meme' do
    create_user

    create_src_image

    visit('/my')
    click_button('Select All')

    set_name = SecureRandom.hex
    fill_in('add-to-set-name', with: set_name)
    click_button('Add 1 to Set:')

    accept_confirm do
      click_button('Delete Set')
    end

    visit("/src_sets/#{set_name}")
    expect(page.status_code).to eq(404)
  end
end
