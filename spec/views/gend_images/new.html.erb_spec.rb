# encoding: UTF-8

require 'spec_helper'

describe 'gend_images/new.html.erb' do

  let(:src_image) { stub_model(SrcImage, id_hash: 'abc', name: 'src image name') }
  let(:caption1) { stub_model(Caption, text: 'text 1') }
  let(:gend_image) { stub_model(GendImage, src_image: src_image, captions: [caption1]) }

  before do
    assign(:gend_image, gend_image)
    assign(:caption_defaults, [{ autofocus: true }, {}])
  end

  it 'renders' do
    render
  end

  it 'uses the src image name as an h1' do
    render

    expect(rendered).to have_selector('h1', content: 'src image name')
  end

  it 'has the src image name in the title' do
    render

    expect(view.content_for(:title)).to eq 'src image name meme'
  end

  it 'has xxlarge text inputs' do
    render

    expect(rendered).to have_selector('#gend_image_captions_attributes_0_text') do |s|
      expect(s.first['class']).to_not be_nil
      expect(s.first['class']).to include 'input-xxlarge'
    end

  end

end
