def create_user
  visit('/users/new')

  fill_in('user_email', with: SecureRandom.hex)
  password = SecureRandom.hex
  fill_in('user_password', with: password)
  fill_in('user_password_confirmation', with: password)

  click_button('Sign Up')

  expect(page).to have_current_path('/my')
end

def press_enter_in(selector)
  execute_script(
    "$('#{selector}').trigger($.Event('keypress', { which: 13 }));"
  )
end

def create_src_image
  fill_in('quick-add-url', with:
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAA' \
    'AAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==')
  press_enter_in('#quick-add-url')

  expect(page).to have_text('URL successfully submitted')
  expect(page).to have_current_path(%r{/gend_images/new\?src=.+}, wait: 10)
end
