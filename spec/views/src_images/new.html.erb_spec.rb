# encoding: UTF-8

require 'spec_helper'

describe 'src_images/new.html.erb' do
  let(:src_image) { FactoryGirl.build(:src_image, image: nil) }

  before do
    src_image.valid?
    assign :src_image, src_image
  end

  it 'shows errors' do
    render

    expect(rendered).to contain 'error'
  end

  it 'has the my images url' do
    render

    selector = '#load-urls-message[data-myurl="http://test.host/my"]'
    expect(rendered).to have_selector(selector)
  end

end
