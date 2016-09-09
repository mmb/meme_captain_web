# encoding: UTF-8

require 'rails_helper'

describe Api::V3::GendImagesController, type: :controller do
  include StatsD::Instrument::Matchers

  let(:user) { FactoryGirl.create(:user) }
  let(:src_image) do
    FactoryGirl.create(:finished_src_image, user: user)
  end

  before(:each) do
    session[:user_id] = user.try(:id)
    request.accept = 'application/json'
  end

  describe "GET 'index'" do
    it 'gets the gend images for the user, query and page' do
      expect(GendImage).to receive(:for_user).with(user, 'test query', '7')
        .and_return(GendImage.none)
      get(:index, q: 'test query', page: '7', format: :json)
    end

    it 'sets the image url on each gend image' do
      gend_image1 = FactoryGirl.create(:finished_gend_image)
      gend_image2 = FactoryGirl.create(:finished_gend_image)
      for_user_result = GendImage.where(id: [gend_image1.id, gend_image2.id])
      allow(GendImage).to receive(:for_user).with(user, nil, nil).and_return(
        for_user_result
      )
      allow(for_user_result).to receive(:includes).with(:captions).and_return(
        [gend_image1, gend_image2]
      )
      expect(gend_image1).to receive(:'image_url=').with(
        "http://test.host/gend_images/#{gend_image1.id_hash}.jpg"
      )
      expect(gend_image2).to receive(:'image_url=').with(
        "http://test.host/gend_images/#{gend_image2.id_hash}.jpg"
      )
      get(:index, format: :json)
    end

    it 'sets the thumbnail url on each gend image' do
      gend_image1 = FactoryGirl.create(:finished_gend_image)
      gend_image2 = FactoryGirl.create(:finished_gend_image)
      for_user_result = GendImage.where(id: [gend_image1.id, gend_image2.id])
      allow(GendImage).to receive(:for_user).with(user, nil, nil).and_return(
        for_user_result
      )
      allow(for_user_result).to receive(:includes).with(:captions).and_return(
        [gend_image1, gend_image2]
      )
      expect(gend_image1).to receive(:'thumbnail_url=').with(
        "http://test.host/gend_thumbs/#{gend_image1.gend_thumb.id}.jpg"
      )
      expect(gend_image2).to receive(:'thumbnail_url=').with(
        "http://test.host/gend_thumbs/#{gend_image2.gend_thumb.id}.jpg"
      )
      get(:index, format: :json)
    end

    it 'returns the gend images as JSON' do
      caption1 = FactoryGirl.create(:caption, text: 'test caption 1')
      caption2 = FactoryGirl.create(:caption, text: 'test caption 2')

      gend_image1 = FactoryGirl.create(:finished_gend_image)
      gend_image2 = FactoryGirl.create(:finished_gend_image,
                                       captions: [caption1])
      gend_image3 = FactoryGirl.create(:finished_gend_image,
                                       captions: [caption1, caption2])
      gend_images = [
        gend_image1,
        gend_image2,
        gend_image3
      ]

      for_user_result = GendImage.where(id: gend_images.map(&:id))
      allow(GendImage).to receive(:for_user).with(user, nil, nil).and_return(
        for_user_result
      )
      allow(for_user_result).to receive(:includes).with(:captions).and_return(
        gend_images
      )
      get(:index, format: :json)
      json_body = JSON.parse(response.body)
      time_format = '%Y-%m-%dT%H:%M:%S.%LZ'
      expect(json_body).to eq(
        [
          {
            'image_url' => 'http://test.host/gend_images/' \
	    "#{gend_image1.id_hash}.jpg",
            'thumbnail_url' => 'http://test.host/gend_thumbs/' \
	    "#{gend_image1.gend_thumb.id}.jpg",
            'content_type' => 'image/jpeg',
            'created_at' => gend_image1.created_at.strftime(time_format),
            'height' => 399,
            'size' => 9141,
            'updated_at' => gend_image1.updated_at.strftime(time_format),
            'width' => 399,
            'captions' => []
          }, {
            'image_url' => 'http://test.host/gend_images/' \
	    "#{gend_image2.id_hash}.jpg",
            'thumbnail_url' => 'http://test.host/gend_thumbs/' \
	    "#{gend_image2.gend_thumb.id}.jpg",
            'content_type' => 'image/jpeg',
            'created_at' => gend_image2.created_at.strftime(time_format),
            'height' => 399,
            'size' => 9141,
            'updated_at' => gend_image2.updated_at.strftime(time_format),
            'width' => 399,
            'captions' => [
              {
                'text' => 'test caption 1',
                'top_left_x_pct' => 1.5,
                'top_left_y_pct' => 1.5,
                'height_pct' => 1.5,
                'width_pct' => 1.5

              }
            ]
          }, {
            'image_url' => 'http://test.host/gend_images/' \
	    "#{gend_image3.id_hash}.jpg",
            'thumbnail_url' => 'http://test.host/gend_thumbs/' \
	    "#{gend_image3.gend_thumb.id}.jpg",
            'content_type' => 'image/jpeg',
            'created_at' => gend_image3.created_at.strftime(time_format),
            'height' => 399,
            'size' => 9141,
            'updated_at' => gend_image3.updated_at.strftime(time_format),
            'width' => 399,
            'captions' => [
              {
                'text' => 'test caption 1',
                'top_left_x_pct' => 1.5,
                'top_left_y_pct' => 1.5,
                'height_pct' => 1.5,
                'width_pct' => 1.5

              },
              {
                'text' => 'test caption 2',
                'top_left_x_pct' => 1.5,
                'top_left_y_pct' => 1.5,
                'height_pct' => 1.5,
                'width_pct' => 1.5

              }
            ]
          }
        ]
      )
    end

    it 'sets the content type to application/json' do
      get(:index, format: :json)
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "POST 'create'" do
    context 'with valid attributes' do
      let(:body) do
        {
          gend_image: {
            src_image_id: src_image.id_hash,
            captions_attributes: {
              '0' => {
                'font' => 'font1',
                'text' => 'hello',
                'top_left_x_pct' => '0.01',
                'top_left_y_pct' => '0.02',
                'width_pct' => '0.03',
                'height_pct' => '0.04'
              },
              '1' => {
                'font' => 'font2',
                'text' => 'world',
                'top_left_x_pct' => '0.05',
                'top_left_y_pct' => '0.06',
                'width_pct' => '0.07',
                'height_pct' => '0.08'
              },
              '2' => {
                'font' => 'font3',
                'text' => '!',
                'top_left_x_pct' => '0.09',
                'top_left_y_pct' => '0.10',
                'width_pct' => '0.11',
                'height_pct' => '0.12'
              }
            },
            private: '1'
          }
        }
      end

      it 'sets the src image' do
        post(:create, body)

        expect(assigns(:gend_image).src_image).to eq(src_image)
      end

      it 'sets the caption 1' do
        post(:create, body)
        caption = assigns(:gend_image).captions[0]

        expect(caption.font).to eq('font1')
        expect(caption.text).to eq('hello')
        expect(caption.top_left_x_pct).to eq(0.01)
        expect(caption.top_left_y_pct).to eq(0.02)
        expect(caption.width_pct).to eq(0.03)
        expect(caption.height_pct).to eq(0.04)
      end

      it 'sets the caption 2' do
        post(:create, body)
        caption = assigns(:gend_image).captions[1]

        expect(caption.font).to eq('font2')
        expect(caption.text).to eq('world')
        expect(caption.top_left_x_pct).to eq(0.05)
        expect(caption.top_left_y_pct).to eq(0.06)
        expect(caption.width_pct).to eq(0.07)
        expect(caption.height_pct).to eq(0.08)
      end

      it 'sets the caption 2' do
        post(:create, body)
        caption = assigns(:gend_image).captions[2]

        expect(caption.font).to eq('font3')
        expect(caption.text).to eq('!')
        expect(caption.top_left_x_pct).to eq(0.09)
        expect(caption.top_left_y_pct).to eq(0.10)
        expect(caption.width_pct).to eq(0.11)
        expect(caption.height_pct).to eq(0.12)
      end

      it 'sets the private flag' do
        post(:create, body)

        expect(assigns(:gend_image).private).to eq(true)
      end

      it 'sets the user to the current user' do
        post(:create, body)

        expect(assigns(:gend_image).user).to eq(user)
      end

      it 'sets the creator ip' do
        post(:create, body)

        expect(assigns(:gend_image).creator_ip).to eq('0.0.0.0')
      end
    end

    it 'saves the image to the database' do
      expect do
        post(:create, gend_image: { src_image_id: src_image.id_hash })
      end.to change { GendImage.count }.by(1)
    end

    it 'responds with ok' do
      post(:create, gend_image: { src_image_id: src_image.id_hash })

      expect(response).to have_http_status(:ok)
    end

    it 'returns application/json as the content type' do
      post(:create, gend_image: { src_image_id: src_image.id_hash })

      expect(response.content_type).to eq('application/json')
    end

    it 'returns a json body with the gend image id' do
      post(:create, gend_image: { src_image_id: src_image.id_hash })

      expect(JSON.parse(response.body)['id']).to eq(
        assigns(:gend_image).id_hash
      )
    end

    it 'returns a json body with the gend image id' do
      post(:create, gend_image: { src_image_id: src_image.id_hash })

      expect(JSON.parse(response.body)['status_url']).to eq(
        'http://test.host/api/v3/pending_gend_images/' \
        "#{assigns(:gend_image).id_hash}"
      )
    end
  end

  context 'with invalid attributes' do
    context 'when the height_pct is missing' do
      let(:body) do
        {
          gend_image: {
            src_image_id: src_image.id_hash,
            captions_attributes: [
              {
                text: 'test',
                top_left_x_pct: 0.05,
                top_left_y_pct: 0.0,
                width_pct: 0.9
              }
            ]
          }
        }
      end

      it 'returns unprocessable entity status' do
        post(:create, body)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error in the response body' do
        post(:create, body)

        expect(JSON.parse(response.body)).to eq(
          'captions.height_pct' => ["can't be blank"]
        )
      end
    end

    context 'when the top_left_x_pct is missing' do
      let(:body) do
        {
          gend_image: {
            src_image_id: src_image.id_hash,
            captions_attributes: [
              {
                text: 'test',
                height_pct: 0.25,
                top_left_y_pct: 0.0,
                width_pct: 0.9
              }
            ]
          }
        }
      end

      it 'returns unprocessable entity status' do
        post(:create, body)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error in the response body' do
        post(:create, body)

        expect(JSON.parse(response.body)).to eq(
          'captions.top_left_x_pct' => ["can't be blank"]
        )
      end
    end

    context 'when the top_left_y_pct is missing' do
      let(:body) do
        {
          gend_image: {
            src_image_id: src_image.id_hash,
            captions_attributes: [
              {
                text: 'test',
                height_pct: 0.25,
                top_left_x_pct: 0.05,
                width_pct: 0.9
              }
            ]
          }
        }
      end

      it 'returns unprocessable entity status' do
        post(:create, body)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error in the response body' do
        post(:create, body)

        expect(JSON.parse(response.body)).to eq(
          'captions.top_left_y_pct' => ["can't be blank"]
        )
      end
    end

    context 'when the width_pct is missing' do
      let(:body) do
        {
          gend_image: {
            src_image_id: src_image.id_hash,
            captions_attributes: [
              {
                text: 'test',
                height_pct: 0.25,
                top_left_x_pct: 0.05,
                top_left_y_pct: 0.0
              }
            ]
          }
        }
      end

      it 'returns unprocessable entity status' do
        post(:create, body)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error in the response body' do
        post(:create, body)

        expect(JSON.parse(response.body)).to eq(
          'captions.width_pct' => ["can't be blank"]
        )
      end
    end
  end

  context 'when the source image is not found' do
    it 'raises record not found' do
      expect do
        post(:create, gend_image: { src_image_id: 'abc' })
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when the source image is still in progress' do
    let(:src_image) { FactoryGirl.create(:src_image, work_in_progress: true) }

    it 'raises record not found' do
      expect do
        post(:create, gend_image: { src_image_id: src_image.id_hash })
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when the source image is deleted' do
    let(:src_image) do
      FactoryGirl.create(:src_image,
                         work_in_progress: false,
                         is_deleted: true)
    end

    it 'raises record not found' do
      expect do
        post(:create, gend_image: { src_image_id: src_image.id_hash })
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when the gend_image parameter is missing' do
    it 'raises record not found' do
      expect do
        post(:create, {})
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
