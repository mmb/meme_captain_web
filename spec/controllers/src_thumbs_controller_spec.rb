require 'time'

require 'rails_helper'

require 'support/stop_time'

describe SrcThumbsController, type: :controller do
  describe "GET 'show'" do
    context 'when the id is found' do
      let(:src_thumb) { FactoryGirl.create(:src_thumb) }

      it 'shows the thumbnail' do
        get(:show, params: { id: src_thumb.id })

        expect(response).to be_success
      end

      it 'has the right content type' do
        get(:show, params: { id: src_thumb.id })

        expect(response.headers['Content-Type']).to eq(src_thumb.content_type)
      end

      it 'has the right Content-Length header' do
        get(:show, params: { id: src_thumb.id })

        expect(response.headers['Content-Length']).to eq(279)
      end

      it 'has the right content' do
        get(:show, params: { id: src_thumb.id })

        expect(response.body).to eq(src_thumb.image)
      end

      it 'has the correct Cache-Control header' do
        get(:show, params: { id: src_thumb.id })

        cache_control = response.headers['Cache-Control']
        expect(cache_control).to eq('max-age=31556952, public')
      end

      it 'has the correct Expires header' do
        stop_time(Time.zone.parse('feb 8 2010 21:55:00 UTC'))
        get(:show, params: { id: src_thumb.id })

        expires_header = response.headers['Expires']
        expect(expires_header).to eq('Tue, 08 Feb 2011 21:55:00 GMT')
      end

      context 'when the image data is in an external object store' do
        let(:src_thumb) do
          FactoryGirl.create(
            :src_thumb,
            image_external_bucket: 'bucket1',
            image_external_key: 'key1'
          )
        end

        before do
          stub_request(:get, 'https://bucket1.s3.amazonaws.com/key1').to_return(
            body: 'data'
          )
          stub_request(
            :get,
            'http://169.254.169.254/latest/meta-data/iam/security-credentials/'
          ).to_return(
            status: 404
          )
          stub_const('ENV', 'AWS_ACCESS_KEY_ID' => 'test',
                            'AWS_SECRET_ACCESS_KEY' => 'test',
                            'AWS_REGION' => 'us-east-1')
        end

        it 'has the right content' do
          get(:show, params: { id: src_thumb.id })

          expect(response.body).to eq('data')
        end
      end
    end

    context 'when the id is not found' do
      it 'raises record not found' do
        expect { get(:show, params: { id: 1 }) }.to raise_error(
          ActiveRecord::RecordNotFound
        )
      end
    end
  end
end
