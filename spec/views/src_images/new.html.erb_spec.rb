# encoding: UTF-8

require 'rails_helper'

describe 'src_images/new.html.erb', type: :view do
  include Webrat::Matchers

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

  it 'sets the content for the title to the src image name' do
    expect(view).to receive(:content_for).with(:title) do |&block|
      expect(block.call).to eq('Meme Captain meme generator upload')
    end
    render
  end
end
