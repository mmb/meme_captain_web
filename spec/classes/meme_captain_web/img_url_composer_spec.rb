require 'rails_helper'

describe MemeCaptainWeb::ImgUrlComposer do
  describe '#load' do
    let(:img_url_composer) { MemeCaptainWeb::ImgUrlComposer.new }

    context 'when the url is just a url' do
      it 'fetches the url and returns the body' do
        img_data = create_image(100, 50)
        url = 'http://example.com/image.jpg'
        stub_request(:get, url).to_return(body: img_data)
        expect(img_url_composer.load(url)).to eq(img_data)
      end
    end

    context 'when the url is a data URI' do
      it 'decodes the data uri and returns the image data' do
        img_data = create_image(100, 50)
        data_uri = "data:image/png;base64,#{Base64.encode64(img_data)}"
        expect(img_url_composer.load(data_uri)).to eq(img_data)
      end
    end

    context 'when the url is a horizontal join' do
      it 'fetches the urls and joins the images horizontally' do
        stub_request(:get, 'http://example.com/image.jpg').to_return(
          body: create_image(100, 50))
        stub_request(:get, 'http://example.com/image2.jpg').to_return(
          body: create_image(100, 75))
        stub_request(:get, 'http://example.com/image3.jpg').to_return(
          body: create_image(100, 100))

        composed_data = img_url_composer.load(
          'http://example.com/image.jpg[]' \
          'http://example.com/image2.jpg[]' \
          'http://example.com/image3.jpg')

        composed_img = Magick::ImageList.new.from_blob(composed_data)

        expect(composed_img.columns).to eq(217)
        expect(composed_img.rows).to eq(50)
      end
    end

    context 'when the url is a vertical join' do
      it 'fetches the urls and joins the images vertically' do
        stub_request(:get, 'http://example.com/image.jpg').to_return(
          body: create_image(100, 50))
        stub_request(:get, 'http://example.com/image2.jpg').to_return(
          body: create_image(105, 50))
        stub_request(:get, 'http://example.com/image3.jpg').to_return(
          body: create_image(110, 50))

        composed_data = img_url_composer.load(
          'http://example.com/image.jpg|' \
          'http://example.com/image2.jpg|' \
          'http://example.com/image3.jpg')

        composed_img = Magick::ImageList.new.from_blob(composed_data)

        expect(composed_img.columns).to eq(100)
        expect(composed_img.rows).to eq(143)
      end
    end

    context 'when the url is a mixed join' do
      it 'fetches the urls and joins the images vertically and horizontally' do
        stub_request(:get, 'http://example.com/image.jpg').to_return(
          body: create_image(100, 100))
        stub_request(:get, 'http://example.com/image2.jpg').to_return(
          body: create_image(100, 100))
        stub_request(:get, 'http://example.com/image3.jpg').to_return(
          body: create_image(100, 100))

        composed_data = img_url_composer.load(
          'http://example.com/image.jpg|' \
          'http://example.com/image2.jpg[]' \
          'http://example.com/image3.jpg')

        composed_img = Magick::ImageList.new.from_blob(composed_data)

        expect(composed_img.columns).to eq(100)
        expect(composed_img.rows).to eq(150)
      end
    end
  end
end
