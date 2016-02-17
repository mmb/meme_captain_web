# encoding: UTF-8

require 'rails_helper'

describe Api::V3::SrcImagesController, type: :controller do
  include StatsD::Instrument::Matchers

  let(:user) { FactoryGirl.create(:user) }

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
    before { request.accept = 'application/json' }

    context 'with valid attributes' do
      context 'when uploading image data' do
        it 'creates a src image with the image data' do
          post(:create, src_image: {
                 image: fixture_file_upload(
                   '/files/ti_duck.jpg', 'image/jpeg') }
              )
          expect(response).to have_http_status(:ok)
          expected_image_data = File.open(
            Rails.root + 'spec/fixtures/files/ti_duck.jpg', 'rb', &:read)

          expect(SrcImage.last.image).to eq(expected_image_data)
        end

        it 'increments the src image upload statsd counter' do
          expect do
            post(:create, src_image: {
                   image: fixture_file_upload(
                     '/files/ti_duck.jpg', 'image/jpeg') }
                )
            expect(response).to have_http_status(:ok)
          end.to trigger_statsd_increment('src_image.upload')
        end
      end

      context 'when loading an image url' do
        it 'creates a src image with the url' do
          post(:create, src_image: { url: 'http://test.com/image.jpg' })
          expect(response).to have_http_status(:ok)
          expect(SrcImage.last.url).to eq('http://test.com/image.jpg')
        end

        it 'does not increment the src image upload statsd counter' do
          expect do
            post(:create, src_image: { url: 'http://test.com/image.jpg' })
            expect(response).to have_http_status(:ok)
          end.to_not trigger_statsd_increment('src_image.upload')
        end
      end

      it 'creates the src image with the private flag' do
        post(:create, src_image: {
               url: 'http://test.com/image.jpg',
               private: true })
        expect(response).to have_http_status(:ok)
        expect(SrcImage.last.private).to eq(true)
      end

      it 'creates the src image with the name' do
        post(:create, src_image: {
               url: 'http://test.com/image.jpg',
               name: 'test name' })
        expect(response).to have_http_status(:ok)
        expect(SrcImage.last.name).to eq('test name')
      end

      it 'creates the src image owned by the current user' do
        post(:create, src_image: {
               url: 'http://test.com/image.jpg' })
        expect(response).to have_http_status(:ok)
        expect(SrcImage.last.user).to eq(user)
      end

      it 'returns ok' do
        post(:create, src_image: {
               url: 'http://test.com/image.jpg' })
        expect(response).to have_http_status(:ok)
      end

      it 'returns json with the src image id' do
        post(:create, src_image: {
               url: 'http://test.com/image.jpg' })
        expect(response).to have_http_status(:ok)
        created_src_image = SrcImage.last
        expect(JSON.parse(response.body)).to include(
          'id' => created_src_image.id_hash)
      end

      it 'returns json with the status url' do
        post(:create, src_image: {
               url: 'http://test.com/image.jpg' })
        expect(response).to have_http_status(:ok)
        created_src_image = SrcImage.last
        expect(JSON.parse(response.body)).to include(
          'status_url' =>
            'http://test.host/api/v3/pending_src_images/' \
            "#{created_src_image.id_hash}")
      end
    end

    context 'with invalid attributes' do
      it 'returns unprocessable entity' do
        post(:create, src_image: { name: 'test name' })
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns json with the errors' do
        post(:create, src_image: { name: 'test name' })
        expect(JSON.parse(response.body)).to eq(
          'image' => ['is required if url is not set.'])
      end
    end
  end
end
