require 'rails_helper'

require 'support/src_image_skip_callbacks'

describe 'errors/index.html.erb', type: :view do
  let(:src_images) do
    [
      FactoryGirl.create(:src_image, error: 'src image 1 error', url: 'http://url1.com/'),
      FactoryGirl.create(:src_image, error: 'src image 2 error', url: 'http://url2.com/')
    ]
  end

  let(:gend_images) do
    [
      FactoryGirl.create(:gend_image, error: 'gend image 1 error'),
      FactoryGirl.create(:gend_image, error: 'gend image 2 error')
    ]
  end

  before do
    assign(:errored_src_images, src_images)
    assign(:errored_gend_images, gend_images)
  end

  it 'shows the src image last updated time' do
    render
    expect(rendered).to have_text(src_images[0].updated_at)
    expect(rendered).to have_text(src_images[1].updated_at)
  end

  it 'shows the src image error' do
    render
    expect(rendered).to have_text('src image 1 error')
    expect(rendered).to have_text('src image 2 error')
  end

  it 'shows the src image url' do
    render
    expect(rendered).to have_text('http://url1.com/')
    expect(rendered).to have_text('http://url2.com/')
  end

  it 'shows the gend image last updated time' do
    render
    expect(rendered).to have_text(gend_images[0].updated_at)
    expect(rendered).to have_text(gend_images[1].updated_at)
  end

  it 'shows the gend image error' do
    render
    expect(rendered).to have_text('gend image 1 error')
    expect(rendered).to have_text('gend image 2 error')
  end
end
