# encoding: UTF-8

require 'rails_helper'

describe GendImagePagesController, type: :controller do
  describe 'show' do
    let(:src_image) { FactoryGirl.create(:src_image) }
    let(:gend_image) do
      FactoryGirl.create(
        :gend_image,
        src_image: src_image,
        captions: [
          FactoryGirl.create(:caption, text: 'caption 1', top_left_y_pct: 0.8),
          FactoryGirl.create(:caption, text: 'caption 2', top_left_y_pct: 0.2)
        ])
    end

    it 'sets the gend image' do
      get :show, id: gend_image.id_hash
      expect(assigns(:gend_image)).to eq gend_image
    end

    it 'sets the src image' do
      get :show, id: gend_image.id_hash
      expect(assigns(:src_image)).to eq src_image
    end

    it 'sets the gend image url' do
      get :show, id: gend_image.id_hash
      expect(assigns(:gend_image_url)).to eq(
        "http://test.host/gend_images/#{gend_image.id_hash}.jpg")
    end

    it 'sets the api script' do
      get(:show, id: gend_image.id_hash)
      expect(assigns(:api_script)).to include(src_image.id_hash)
      expect(assigns(:api_script)).to include('http://test.host/gend_images')
      expect(assigns(:api_script)).to include('caption 1')
      expect(assigns(:api_script)).to include('caption 2')
    end

    context 'when the gend image is less than 10 seconds old' do
      it 'refreshes in 2 seconds' do
        get :show, id: gend_image.id_hash
        expect(assigns(:refresh_in)).to eq 2
      end
    end

    context 'when the gend image is more than 10 seconds old' do
      it 'does not refresh' do
        gend_image

        Timecop.freeze(20) do
          get :show, id: gend_image.id_hash
          expect(assigns(:refresh_in)).to be_nil
        end
      end
    end

    context 'when the image has been deleted' do
      let(:gend_image) do
        FactoryGirl.create(:gend_image, src_image: src_image, is_deleted: true)
      end

      it 'raises record not found' do
        expect do
          get :show, id: gend_image.id_hash
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
