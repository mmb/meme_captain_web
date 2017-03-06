require 'rails_helper'

describe 'gend_images/new.html.erb', type: :view do
  let(:caption1) { FactoryGirl.create(:caption) }
  let(:gend_image) { FactoryGirl.create(:gend_image, captions: [caption1]) }

  before do
    assign(:gend_image, gend_image)
    assign(:caption_defaults, [{}, {}])
    assign(:src_image_url_with_extension, 'src image url with extension')
    def view.current_user
      nil
    end
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
      '#gend_image_captions_attributes_0_text'
    ) do |s|
      expect(s.first['class']).to_not be_nil
      expect(s.first['class']).to include 'form-control'
    end
  end

  it 'has a hidden negative captcha field called email' do
    render

    expect(rendered).to have_selector('#gend_image_email', visible: false)
  end

  context 'when the gend image is not private' do
    let(:gend_image) { FactoryGirl.create(:gend_image, private: false) }

    it 'does not check the private checkbox' do
      expect(render).to_not have_selector(
        'input[checked=checked][type="checkbox"][name="gend_image[private]"]'
      )
    end
  end

  context 'when the gend image is private' do
    let(:gend_image) { FactoryGirl.create(:gend_image, private: true) }

    it 'checks the private checkbox' do
      expect(render).to have_selector(
        'input[checked=checked][type="checkbox"][name="gend_image[private]"]'
      )
    end
  end

  describe 'text positioner' do
    it 'sets the data-img-url to the src image url' do
      expect(render).to have_selector(
        'div.text-positioner[data-img-url="src image url with extension"]'
      )
    end
  end

  context 'when the user can edit the src image' do
    before { assign(:can_edit_src_image, true) }

    it 'shows the set default captions button' do
      expect(render).to have_text('Set as default captions')
    end
  end

  context 'when the user cannot edit the src image' do
    before { assign(:can_edit_src_image, false) }

    it 'does not show the set default captions button' do
      expect(render).to_not have_text('Set as default captions')
    end
  end
end
