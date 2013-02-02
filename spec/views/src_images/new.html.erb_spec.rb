require 'spec_helper'

describe "src_images/new.html.erb" do
  it 'shows errors' do
    src_image = FactoryGirl.build(:src_image, :image => nil)
    src_image.valid?

    assign :src_image, src_image

    render

    expect(rendered).to contain 'errors'
  end
end
