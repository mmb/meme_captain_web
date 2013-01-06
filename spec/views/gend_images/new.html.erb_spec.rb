require 'spec_helper'

describe 'gend_images/new.html.erb' do

  it 'renders' do
    assign(:gend_image, stub_model(GendImage, :src_image => stub_model(SrcImage)))
    render
  end

end
