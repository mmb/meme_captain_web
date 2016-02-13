# encoding: UTF-8

require 'rails_helper'

describe Api::V3::SrcImagesController, type: :controller do
  include StatsD::Instrument::Matchers

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user, email: 'user2@user2.com') }

  before(:each) do
    session[:user_id] = user.try(:id)
  end

  describe "GET 'index'" do
    let(:src_image1) do
      FactoryGirl.create(:finished_src_image, name: 'src image 1')
    end

    let(:src_image2) do
      FactoryGirl.create(:finished_src_image, name: 'src image 2')
    end

    let(:src_image3) do
      FactoryGirl.create(:finished_src_image, name: 'src image 3')
    end

    let(:src_images) { [src_image1, src_image2, src_image3] }

    before do
      src_images.each do |src_image|
        src_image.set_derived_image_fields
        src_image.save!
      end
    end

    it 'gets the src images for the user, query and page' do
      expect(SrcImage).to receive(:for_user).with(user, 'test query', '7')
        .and_return(src_images)
      get(:index, q: 'test query', page: '7', format: :json)
    end

    it 'sets the image url on each src image' do
      allow(SrcImage).to receive(:for_user).with(user, nil, nil).and_return(
        src_images)
      expect(src_image1).to receive(:image_url=).with(
        "http://test.host/src_images/#{src_image1.id_hash}.jpg")
      expect(src_image2).to receive(:image_url=).with(
        "http://test.host/src_images/#{src_image2.id_hash}.jpg")
      expect(src_image3).to receive(:image_url=).with(
        "http://test.host/src_images/#{src_image3.id_hash}.jpg")
      get(:index, format: :json)
    end

    it 'returns the src images as JSON' do
      allow(SrcImage).to receive(:for_user).with(user, nil, nil).and_return(
        src_images)
      get(:index, format: :json)
      json_body = JSON.parse(response.body)
      expect(json_body).to eq(
        [
          {
            'id_hash' => src_image1.id_hash,
            'width' => 399,
            'height' => 399,
            'size' => 9141,
            'content_type' => 'image/jpeg',
            'created_at' => src_image1.created_at.strftime(
              '%Y-%m-%dT%H:%M:%S.%LZ'),
            'updated_at' => src_image1.updated_at.strftime(
              '%Y-%m-%dT%H:%M:%S.%LZ'),
            'name' => 'src image 1',
            'image_url' =>
        "http://test.host/src_images/#{src_image1.id_hash}.jpg"
          }, {
            'id_hash' => src_image2.id_hash,
            'width' => 399,
            'height' => 399,
            'size' => 9141,
            'content_type' => 'image/jpeg',
            'created_at' => src_image2.created_at.strftime(
              '%Y-%m-%dT%H:%M:%S.%LZ'),
            'updated_at' => src_image2.updated_at.strftime(
              '%Y-%m-%dT%H:%M:%S.%LZ'),
            'name' => 'src image 2',
            'image_url' =>
        "http://test.host/src_images/#{src_image2.id_hash}.jpg"
          }, {
            'id_hash' => src_image3.id_hash,
            'width' => 399,
            'height' => 399,
            'size' => 9141,
            'content_type' => 'image/jpeg',
            'created_at' => src_image3.created_at.strftime(
              '%Y-%m-%dT%H:%M:%S.%LZ'),
            'updated_at' => src_image3.updated_at.strftime(
              '%Y-%m-%dT%H:%M:%S.%LZ'),
            'name' => 'src image 3',
            'image_url' =>
        "http://test.host/src_images/#{src_image3.id_hash}.jpg"
          }
        ])
    end

    it 'sets the content type to application/json' do
      get(:index, format: :json)
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "POST 'create'" do
    let(:image) { fixture_file_upload('/files/ti_duck.jpg', 'image/jpeg') }

    context 'with valid attributes' do
      context 'when the user requests json' do
        before { request.accept = 'application/json' }

        it 'returns accepted' do
          post :create, src_image: { url: 'http://test.com/image.jpg' }
          expect(response).to have_http_status(:accepted)
        end

        it 'returns json with id' do
          post :create, src_image: { url: 'http://test.com/image.jpg' }
          expect(JSON.parse(response.body)['id']).to eq(
            assigns(:src_image).id_hash)
        end

        it 'sets the Location header to the pending src image url' do
          post :create, src_image: { url: 'http://test.com/image.jpg' }
          expect(response.headers['Location']).to eq(
            'http://test.host/api/v3/pending_src_images/' \
            "#{assigns(:src_image).id_hash}")
        end

        it 'returns the status url in the response' do
          post(:create, src_image: { url: 'http://test.com/image.jpg' })

          expect(JSON.parse(response.body)['status_url']).to eq(
            'http://test.host/api/v3/pending_src_images/' \
            "#{assigns(:src_image).id_hash}")
        end
      end
    end
  end
end
