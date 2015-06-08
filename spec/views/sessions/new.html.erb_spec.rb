# encoding: UTF-8

require 'rails_helper'

describe 'sessions/new.html.erb', type: :view do
  include Webrat::Matchers

  it 'has an email field' do
    render
    expect(render).to have_selector('input', id: 'email')
  end

  it 'has a password field' do
    render
    expect(render).to have_selector('input', id: 'email')
  end
end
