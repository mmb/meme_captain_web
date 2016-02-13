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
    context 'when JSON is requested' do
      it 'serves JSON' do
        src_image1 = FactoryGirl.create(
          :src_image,
          name: 'image 1',
          work_in_progress: false)
        src_image1.set_derived_image_fields
        src_image1.save!
        2.times { FactoryGirl.create(:gend_image, src_image: src_image1) }

        Timecop.travel(Time.now + 1)

        src_image2 = FactoryGirl.create(
          :src_image,
          name: 'image 1',
          work_in_progress: false)
        src_image2.set_derived_image_fields
        src_image2.save!
        1.times { FactoryGirl.create(:gend_image, src_image: src_image2) }

        get :index, format: :json
        parsed_body = JSON.parse(response.body)
        expect(parsed_body[0]).to include(
          'id_hash' => src_image1.id_hash,
          'width' => 399,
          'height' => 399,
          'size' => 9141,
          'content_type' => 'image/jpeg',
          'name' => 'image 1',
          'image_url' =>
               "http://test.host/src_images/#{src_image1.id_hash}.jpg")
        expect(Time.parse(parsed_body[0]['created_at']).to_i).to eq(
          src_image1.created_at.to_i)
        expect(Time.parse(parsed_body[0]['updated_at']).to_i).to eq(
          src_image1.updated_at.to_i)

        expect(parsed_body[1]).to include(
          'id_hash' => src_image2.id_hash,
          'width' => 399,
          'height' => 399,
          'size' => 9141,
          'content_type' => 'image/jpeg',
          'name' => 'image 1',
          'image_url' =>
              "http://test.host/src_images/#{src_image2.id_hash}.jpg")
        expect(Time.parse(parsed_body[1]['created_at']).to_i).to eq(
          src_image2.created_at.to_i)
        expect(Time.parse(parsed_body[1]['updated_at']).to_i).to eq(
          src_image2.updated_at.to_i)
      end

      context 'when a gend image host is set in the config' do
        before do
          stub_const('MemeCaptainWeb::Config::GEND_IMAGE_HOST',
                     'gendimagehost.com')
        end

        it 'uses the gend image host in src image urls' do
          src_image1 = FactoryGirl.create(
            :src_image,
            name: 'image 1',
            work_in_progress: false)
          src_image1.set_derived_image_fields
          src_image1.save!

          get :index, format: :json
          parsed_body = JSON.parse(response.body)
          expect(parsed_body[0]).to include(
            'id_hash' => src_image1.id_hash,
            'width' => 399,
            'height' => 399,
            'size' => 9141,
            'content_type' => 'image/jpeg',
            'name' => 'image 1',
            'image_url' =>
  "http://gendimagehost.com/src_images/#{src_image1.id_hash}.jpg"
          )
          expect(Time.parse(parsed_body[0]['created_at']).to_i).to eq(
            src_image1.created_at.to_i)
          expect(Time.parse(parsed_body[0]['updated_at']).to_i).to eq(
            src_image1.updated_at.to_i)
        end
      end
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

  describe "PUT 'update'" do
    context 'when owned by the current user' do
      let(:src_image) do
        FactoryGirl.create(:src_image, name: 'pre', user: user)
      end

      it 'updates the name' do
        request.accept = 'application/json'
        put :update, id: src_image.id_hash, src_image: { name: 'test' }

        expect(SrcImage.find_by(id_hash: src_image.id_hash).name).to eq('test')
      end
    end

    context 'when not owned by the current user' do
      let(:src_image) do
        FactoryGirl.create(:src_image, name: 'pre', user: user2)
      end

      it 'does not change the name' do
        request.accept = 'application/json'
        put :update, id: src_image.id_hash, src_image: { name: 'test' }

        expect(SrcImage.find_by(id_hash: src_image.id_hash).name).to eq('pre')
      end
    end
  end

  describe "GET 'show'" do
    context 'when the id is found' do
      let(:src_image) do
        src_image = FactoryGirl.create(:src_image, work_in_progress: false)
        src_image.set_derived_image_fields
        src_image.save!
        src_image
      end

      it 'shows the source image' do
        get 'show', id: src_image.id_hash

        expect(response).to be_success
      end

      it 'has the right content type' do
        get 'show', id: src_image.id_hash

        expect(response.content_type).to eq(src_image.content_type)
      end

      it 'has the right Content-Length header' do
        get('show', id: src_image.id_hash)

        expect(response.headers['Content-Length']).to eq(9141)
      end

      it 'has the right content' do
        get 'show', id: src_image.id_hash

        expect(response.body).to eq(src_image.image)
      end
    end

    context 'when the id is not found' do
      it 'raises record not found' do
        expect do
          get 'show', id: 'does not exist'
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the source image has been deleted' do
      let(:src_image) do
        FactoryGirl.create(
          :src_image,
          work_in_progress: false,
          is_deleted: true)
      end

      it 'raises record not found' do
        expect do
          get 'show', id: src_image.id_hash
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
