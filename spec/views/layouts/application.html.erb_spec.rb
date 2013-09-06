# encoding: UTF-8

require 'spec_helper'

describe 'layouts/application.html.erb' do

  it 'has the right title' do
    render

    expect(rendered).to have_selector('title',
                                      content: 'Meme Captain meme generator')
  end

end
