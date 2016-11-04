require 'rails_helper'

require 'support/features'

RSpec.feature 'quick add url', type: :feature, js: true do
  scenario 'quick add url' do
    create_user

    fill_in('quick-add-url', with:
      'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAA' \
      'AAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==')
    press_enter_in('#quick-add-url')

    expect(page).to have_text('URL successfully submitted')
    expect(page).to have_current_path(%r{/gend_images/new\?src=.+}, wait: 5)
  end
end
