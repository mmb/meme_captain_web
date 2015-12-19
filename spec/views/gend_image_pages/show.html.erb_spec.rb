# encoding: UTF-8

require 'rails_helper'

require 'cgi'

describe 'gend_image_pages/show.html.erb', type: :view do
  let(:gend_image) do
    FactoryGirl.create(
      :gend_image,
      work_in_progress: false,
      captions: [
        FactoryGirl.create(:caption, text: 'caption 1', top_left_y_pct: 0.8),
        FactoryGirl.create(:caption, text: 'caption 2', top_left_y_pct: 0.2)
      ])
  end

  let(:src_image) { FactoryGirl.create(:src_image) }
  let(:gend_image_url) do
    "http://test.host/gend_images/#{gend_image.id_hash}.jpg"
  end
  let(:android) { false }
  let(:mobile) { false }
  let(:browser) { instance_double('Browser') }

  before do
    assign(:gend_image, gend_image)
    assign(:src_image, src_image)
    assign(:gend_image_url, gend_image_url)

    allow(view).to receive(:browser).with(no_args).and_return(browser)
    allow(browser).to receive(:android?).with(no_args).and_return(android)
    allow(browser).to receive(:mobile?).with(no_args).and_return(mobile)
    allow(view).to receive(:content_for)
  end

  context 'when the src image has a name' do
    let(:src_image) { FactoryGirl.create(:src_image, name: 'test src') }

    it 'sets the content for the title to the src image name' do
      expect(view).to receive(:content_for).with(:title) do |&block|
        expect(block.call).to eq('test src meme')
      end
      render
    end
  end

  context 'when the src image does not have a name' do
    let(:src_image) { FactoryGirl.create(:src_image, name: '') }

    it 'does not set the content for the title to the src image name' do
      expect(view).to_not receive(:content_for).with(:title)
      render
    end
  end

  it 'sets the content for the description to the meme captions' do
    expect(view).to receive(:content_for).with(
      :description, 'caption 2 caption 1')
    render
  end

  context 'browser' do
    context 'when the browser is not Android' do
      it 'does not have the SMS button' do
        expect(render).to_not have_link('SMS')
      end
    end

    context 'when the browser is Android' do
      let(:android) { true }

      it 'has the SMS button' do
        expect(render).to have_link('SMS')
      end
    end

    context 'when the browser is not mobile' do
      let(:mobile) { false }

      it 'does not have the WhatsApp button' do
        params = { text: gend_image_url }.to_query
        expect(render).to_not have_link(
          'WhatsApp', href: "whatsapp://send?#{params}")
      end
    end

    context 'when the browser is mobile' do
      let(:mobile) { true }

      it 'has the WhatsApp button' do
        params = { text: gend_image_url }.to_query
        expect(render).to have_link(
          'WhatsApp', href: "whatsapp://send?#{params}")
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
      expect(render).to have_selector("img[src='#{img_src}']")
    end

    it 'dismisses the modal when the QR code image is clicked' do
      expect(render).to have_selector(
        "img[src='#{img_src}'][data-dismiss='modal']")
    end
  end

  context 'when the image is not animated' do
    it 'does not have the gfycat button' do
      expect(render).to_not have_link('Gfycat')
    end
  end

  context 'when the image is animated' do
    let(:gend_image) do
      FactoryGirl.create(
        :animated_gend_image, work_in_progress: false, private: privat)
    end

    context 'when the image is private' do
      let(:privat) { true }

      it 'does not have the gfycat button' do
        expect(render).to_not have_link('Gfycat')
      end
    end

    context 'when the image is not private' do
      let(:privat) { false }

      it 'has the gfycat button' do
        expect(render).to have_link('Gfycat')
      end
    end
  end

  it 'includes the created time as a time element' do
    created_at = gend_image.created_at.strftime('%Y-%m-%dT%H:%M:%SZ')
    expect(render).to have_selector("time[datetime='#{created_at}']")
  end

  it "uses the image's meme text as alt text" do
    expect(render).to have_selector(
      "img[src='#{gend_image_url}'][alt='caption 2 caption 1']")
  end

  context 'API shell script modal' do
    it 'has an API button' do
      expect(render).to have_link(
        'API', href: "/gend_image_scripts/#{gend_image.id_hash}.txt")
    end
  end

  context 'when the image is not private' do
    let(:gend_image) do
      FactoryGirl.create(:gend_image, private: false, work_in_progress: false)
    end

    it 'shows the Reddit button' do
      expect(render).to have_link('Reddit')
    end

    it 'shows the Tweet button' do
      expect(render).to have_link('Tweet')
    end

    it 'shows the Pinterest button' do
      expect(render).to have_link('Pinterest')
    end

    it 'shows the Facebook button' do
      expect(render).to have_link('Facebook')
    end

    it 'shows the Google+ button' do
      expect(render).to have_link('Google+')
    end
  end

  context 'when the image is private' do
    let(:gend_image) do
      FactoryGirl.create(:gend_image, private: true, work_in_progress: false)
    end

    it 'does not show the Reddit button' do
      expect(render).to_not have_link('Reddit')
    end

    it 'does not show the Tweet button' do
      expect(render).to_not have_link('Tweet')
    end

    it 'does not show the Pinterest button' do
      expect(render).to_not have_link('Pinterest')
    end

    it 'does not show the Facebook button' do
      expect(render).to_not have_link('Facebook')
    end

    it 'does not show the Google+ button' do
      expect(render).to_not have_link('Google+')
    end
  end
end
