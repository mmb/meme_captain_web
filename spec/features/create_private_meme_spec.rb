require 'rails_helper'

require 'support/features'

RSpec.feature 'create private meme', type: :feature, js: true do
  scenario 'create private meme' do
    create_user

    fill_in('quick-add-url', with:
      'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAA' \
      'AAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==')
    press_enter_in('#quick-add-url')

    expect(page).to have_text('URL successfully submitted')
    expect(page).to have_current_path(%r{/gend_images/new\?src=.+}, wait: 10)

    check('Private?')

    click_button('Create')

    expect(page).to have_text('Submitted request')
    expect(page).to have_current_path(%r{/gend_image_pages/.+}, wait: 10)
    expect(page.html).to include('Private')
  end
end
