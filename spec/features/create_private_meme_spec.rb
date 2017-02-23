require 'rails_helper'

require 'support/features'

RSpec.feature 'create private meme', type: :feature, js: true do
  scenario 'create private meme' do
    create_user

    create_src_image

    check('Private?')

    click_button('Create')

    expect(page).to have_text('Submitted request')
    expect(page).to have_current_path(%r{/gend_image_pages/.+}, wait: 10)
    expect(page.html).to include('Private')
  end
end
