# encoding: UTF-8

require 'rails_helper'

describe 'layouts/application.html.erb', type: :view do
  include Webrat::Matchers

  it 'has the right title' do
    render

    expect(rendered).to have_selector('title',
                                      content: 'Meme Captain meme generator')
  end

  it 'sets the viewport' do
    render

    expect(rendered).to have_selector(
      'meta',
      'name' => 'viewport',
      'content' => 'width=device-width, ' \
      'initial-scale=1, maximum-scale=1')
  end

  it 'has an apple-touch-icon.png' do
    render

    expect(rendered).to have_selector(
      'link',
      'rel' => 'apple-touch-icon',
      'href' => '/assets/apple-touch-icon.png')
  end

  it 'sets the tabindex of the search box to 1' do
    render

    expect(rendered).to have_selector(
      'input#q',
      'tabindex' => '1')
  end

  it 'sets the tabindex of the load url box to 2' do
    render

    expect(rendered).to have_selector(
      'input#quick-add-url',
      'tabindex' => '2')
  end
end
