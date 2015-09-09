# encoding: UTF-8

require 'rails_helper'

describe 'gend_images/new.html.erb', type: :view do
  let(:src_image) do
    stub_model(SrcImage, id_hash: 'abc', name: 'src image name')
  end
  let(:caption1) { stub_model(Caption, text: 'text 1') }
  let(:gend_image) do
    stub_model(GendImage, src_image: src_image, captions: [caption1])
  end

  before do
    assign(:gend_image, gend_image)
    assign(:caption_defaults, [{}, {}])
    assign(:src_image_url_with_extension, 'src image url with extension')
  end

  it 'renders' do
    render
  end

  it 'uses the src image name as an h1' do
    render

    expect(rendered).to have_xpath('//h1/span[text()="src image name"]')
  end

  it 'has the src image name in the title' do
    render

    expect(view.content_for(:title)).to eq 'src image name meme generator'
  end

  it 'has text inputs with the form control class' do
    render

    expect(rendered).to have_selector(
      '#gend_image_captions_attributes_0_text') do |s|
      expect(s.first['class']).to_not be_nil
      expect(s.first['class']).to include 'form-control'
    end
  end

  it 'has a hidden negative captcha field called email' do
    render

    expect(rendered).to have_selector('#gend_image_email', visible: false)
  end

  context 'when the gend image is not private' do
    let(:gend_image) do
      stub_model(
        GendImage, src_image: src_image, captions: [caption1], private: false)
    end

    it 'does not check the private checkbox' do
      expect(render).to_not have_selector(
        'input[checked=checked][type="checkbox"][name="gend_image[private]"]')
    end
  end

  context 'when the gend image is private' do
    let(:gend_image) do
      stub_model(
        GendImage, src_image: src_image, captions: [caption1], private: true)
    end

    it 'checks the private checkbox' do
      expect(render).to have_selector(
        'input[checked=checked][type="checkbox"][name="gend_image[private]"]')
    end
  end

  describe 'text positioner' do
    it 'sets the data-img-url to the src image url' do
      expect(render).to have_selector(
        'div.text-positioner[data-img-url="src image url with extension"]')
    end
  end
end
