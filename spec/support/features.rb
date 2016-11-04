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
