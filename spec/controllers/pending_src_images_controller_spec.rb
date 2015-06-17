# encoding: UTF-8

require 'rails_helper'

describe PendingSrcImagesController, type: :controller do
  describe "GET 'show'" do
    let(:src_image) do
      FactoryGirl.create(:src_image)
    end

    before do
      src_image.set_derived_image_fields
      src_image.save!
    end

    context 'when the image is not found' do
      it 'returns not found status' do
        expect do
          get(:show, id: 'does-not-exist')
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the image has been deleted' do
      let(:src_image) do
        FactoryGirl.create(:src_image, is_deleted: true)
      end

      it 'returns not found status' do
        expect do
          get(:show, id: 'does-not-exist')
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the image is found' do
      context 'when the image is still being processed' do
        it 'returns accepted status' do
          get(:show, id: src_image.id_hash)
          expect(response).to be_success
        end

        it 'returns json with the created time' do
          get(:show, id: src_image.id_hash)
          expect(response.content_type).to eq('application/json')
          parsed_json = JSON.parse(response.body)
          expect(Time.parse(parsed_json['created_at']).to_i).to eq(
            src_image.created_at.to_i)
        end
      end

      context 'when the image is finished being processed' do
        let(:src_image) do
          FactoryGirl.create(:src_image, work_in_progress: false)
        end

        it 'redirects to image with see other' do
          get :show, id: src_image.id_hash
          expect(response).to have_http_status(303)
          expect(response).to redirect_to(
            "http://test.host/src_images/#{src_image.id_hash}.jpg")
        end
      end
    end
  end
end
