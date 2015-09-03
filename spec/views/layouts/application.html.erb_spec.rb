# encoding: UTF-8

require 'rails_helper'

describe 'layouts/application.html.erb', type: :view do
  include Webrat::Matchers

  it 'has the right title' do
    render

    expect(rendered).to have_selector('title',
                                      content: 'Meme Captain meme generator')
  end

  it 'sets the meta description using content_for' do
    allow(view).to receive(:content_for).with(:description).and_return(
      'test description')

    render

    expect(rendered).to have_selector(
      'meta',
      'name' => 'description',
      'content' => 'test description')
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

  describe 'footer' do
    it 'has a link to the API documentation' do
      render

      expect(rendered).to have_selector(
        'a',
        href: 'https://github.com/mmb/meme_captain_web/tree/master/doc/api',
        content: 'API documentation')
    end
  end

  context 'when the page is served using SSL' do
    before do
      allow(controller.request).to receive(:ssl?).and_return(true)
    end

    it 'loads the gravatar using SSL' do
      user = FactoryGirl.create(:user)
      allow(view).to receive(:current_user).with(no_args).and_return(user)
      render
      expect(rendered).to have_selector(
        'img[src^="https://secure.gravatar.com"]')
    end
  end
end
