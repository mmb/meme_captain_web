require 'rails_helper'

describe SrcImageNameJob, type: :job do
  let(:src_image) { FactoryGirl.create(:src_image, name: current_name) }

  before do
    allow(Rails.application.config).to receive(:asset_host).and_return(
      asset_host)
  end

  context 'when no asset host is configured' do
    let(:asset_host) { nil }
    let(:current_name) { nil }

    it 'does not change the src image name' do
      expect do
        SrcImageNameJob.perform_now(src_image)
      end.to_not change { src_image.name }
    end
  end

  context 'when an asset host is configured' do
    let(:asset_host) { 'yourassets.com' }

    context 'when the src image is private' do
      let(:src_image) do
        FactoryGirl.create(:src_image, private: true, name: '')
      end

      it 'does not change the src image name' do
        expect do
          SrcImageNameJob.perform_now(src_image)
        end.to_not change { src_image.name }
      end
    end

    context 'when the src image already has a name' do
      let(:current_name) { 'current name' }

      it 'does not change the src image name' do
        expect do
          SrcImageNameJob.perform_now(src_image)
        end.to_not change { src_image.name }
      end
    end

    context 'when the src image name is nil' do
      let(:current_name) { nil }

      before do
        stub_request(:get, 'http://google.com/imghp?hl=en&tab=wi')
        search_url = 'http://google.com/searchbyimage?' \
          "image_url=http://yourassets.com/src_images/#{src_image.id_hash}"
        stub_request(:get, search_url).to_return(body: body)
      end

      context 'when Google cannot identify the image' do
        let(:body) { 'no guess' }

        it 'does not change the src image name' do
          expect do
            SrcImageNameJob.perform_now(src_image)
          end.to_not change { src_image.name }
        end
      end

      context 'when Google can identify the image' do
        let(:body) do
          '<div class="_hUb">Best guess for this image:&nbsp;' \
          '<a class="_gUb" href="/search?q=test+image&amp;sa=X' \
          '&amp;ei=fVVhVZjvOYuQsAXS3YHYBg&amp;ved=0CB0QvQ4oAw" ' \
          'style="font-style:italic">test image</a></div>'
        end

        it "sets the name to Google's description of the image" do
          expect do
            SrcImageNameJob.perform_now(src_image)
          end.to change { src_image.name }.to('test image')
        end
      end
    end

    context 'when the src image name is empty' do
      let(:current_name) { '' }

      before do
        stub_request(:get, 'http://google.com/imghp?hl=en&tab=wi')
        search_url = 'http://google.com/searchbyimage?' \
          "image_url=http://yourassets.com/src_images/#{src_image.id_hash}"
        stub_request(:get, search_url).to_return(body: body)
      end

      context 'when Google can identify the image' do
        let(:body) do
          '<div class="_hUb">Best guess for this image:&nbsp;' \
          '<a class="_gUb" href="/search?q=test+image&amp;sa=X' \
          '&amp;ei=fVVhVZjvOYuQsAXS3YHYBg&amp;ved=0CB0QvQ4oAw" ' \
          'style="font-style:italic">test image</a></div>'
        end

        it "sets the name to Google's description of the image" do
          expect do
            SrcImageNameJob.perform_now(src_image)
          end.to change { src_image.name }.to('test image')
        end
      end
    end
  end
end
