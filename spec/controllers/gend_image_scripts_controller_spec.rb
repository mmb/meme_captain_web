require 'rails_helper'

describe GendImageScriptsController, type: :controller do
  describe '#show' do
    context 'when the image is deleted' do
      let(:gend_image) do
        FactoryGirl.create(
          :gend_image, is_deleted: true, work_in_progress: false
        )
      end

      it 'raises record not found' do
        expect do
          get(:show, params: { id: gend_image.id_hash })
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the image is not finished' do
      let(:gend_image) do
        FactoryGirl.create(:gend_image, work_in_progress: true)
      end

      it 'raises record not found' do
        expect do
          get(:show, params: { id: gend_image.id_hash })
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the image doesn't exist" do
      it 'raises record not found' do
        expect do
          get(:show, params: { id: 'not here' })
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the image is found' do
      let(:gend_image) do
        FactoryGirl.create(:gend_image, work_in_progress: false)
      end

      it 'assigns the endpoint' do
        get(:show, params: { id: gend_image.id_hash, format: :text })
        expect(assigns(:endpoint)).to eq('http://test.host/api/v3/gend_images')
      end

      it 'assigns the json' do
        gend_image_api_request_json = instance_double(
          MemeCaptainWeb::GendImageApiRequestJson
        )
        expect(MemeCaptainWeb::GendImageApiRequestJson).to receive(:new).with(
          gend_image
        ).and_return(gend_image_api_request_json)
        expect(gend_image_api_request_json).to receive(:json).and_return(
          'test json'
        )

        get(:show, params: { id: gend_image.id_hash, format: :text })
        expect(assigns(:json)).to eq('test json')
      end

      it 'has text/plain as the content type' do
        get(:show, params: { id: gend_image.id_hash, format: :text })
        expect(response.content_type).to eq('text/plain')
      end
    end
  end
end
