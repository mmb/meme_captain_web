# encoding: UTF-8

require 'rails_helper'

require 'cgi'

describe 'gend_image_pages/show.html.erb', type: :view do
  include Webrat::Matchers

  let(:gend_image) { FactoryGirl.create(:gend_image, work_in_progress: false) }
  let(:src_image) { FactoryGirl.create(:src_image) }
  let(:gend_image_url) do
    url_for(controller: :gend_images, action: :show, id: gend_image.id_hash)
  end
  let(:android) { false }
  let(:browser) { instance_double('Browser') }

  before do
    assign(:gend_image, gend_image)
    assign(:src_image, src_image)
    assign(:gend_image_url, gend_image_url)

    allow(view).to receive(:browser).with(no_args).and_return(browser)
    allow(browser).to receive(:android?).with(no_args).and_return(android)
  end

  context 'browser' do

    context 'when the browser is not Android' do

      it 'does not have the SMS button' do
        expect(render).to_not contain 'SMS'
      end

    end

    context 'when the browser is Android' do
      let(:android) { true }

      it 'has the SMS button' do
        expect(render).to contain 'SMS'
      end
    end
  end

  it 'has the image width' do
    expect(render).to have_selector 'img[width="399"]'
  end

  it 'has the image height' do
    expect(render).to have_selector 'img[height="399"]'
  end

  it 'has a link to create a new image' do
    selector = "a[href=\"/gend_images/new?src=#{src_image.id_hash}\"]"

    expect(render).to have_selector(selector)
  end

  context 'QR code modal' do
    let(:img_src) do
      'https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=' \
      "#{CGI.escape(gend_image_url)}"
    end

    it 'has a modal body with a QR code' do
      expect(render).to have_selector('img', src: img_src)
    end

    it 'dismisses the modal when the QR code image is clicked' do
      expect(render).to have_selector(
                            'img', src: img_src, 'data-dismiss' => 'modal')
    end
  end

  context 'when the image is not animated' do
    it 'does not have the gfycat button' do
      expect(render).to_not contain 'Gfycat'
    end
  end

  context 'when the image is animated' do
    let(:gend_image) do
      FactoryGirl.create(
          :gend_image,
          work_in_progress: false,
          image: File.read(Rails.root + 'spec/fixtures/files/omgcat.gif'))
    end

    it 'has the gfycat button' do
      expect(render).to contain 'Gfycat'
    end
  end

  it 'includes the created time as a time element' do
    expect(render).to have_selector('time',
                                    datetime: gend_image.created_at.strftime(
                                        '%Y-%m-%dT%H:%M:%SZ'))
  end
end
