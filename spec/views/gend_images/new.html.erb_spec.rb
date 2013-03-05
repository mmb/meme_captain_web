require 'spec_helper'

describe 'gend_images/new.html.erb' do

  let(:src_image) { stub_model(SrcImage, :id_hash => 'abc') }
  let(:gend_image) { stub_model(GendImage, :src_image => src_image) }

  it 'renders' do
    assign(:gend_image, gend_image)
    render
  end

end
