# encoding: UTF-8

require 'spec_helper'

describe 'gend_images/new.html.erb' do

  let(:src_image) { stub_model(SrcImage, id_hash: 'abc', name: 'src image name') }
  let(:gend_image) { stub_model(GendImage, src_image: src_image) }

  before do
    assign(:gend_image, gend_image)
  end

  it 'renders' do
    render
  end

  it 'uses the src image name as an h1' do
    render

    expect(rendered).to have_selector('h1', content: 'src image name')
  end

end
