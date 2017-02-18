require 'rails_helper'

describe 'sessions/new.html.erb', type: :view do
  it 'has an email field' do
    render
    expect(render).to have_selector('input#email')
  end

  it 'has a password field' do
    render
    expect(render).to have_selector('input#email')
  end
end
