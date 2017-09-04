require 'rails_helper'

require 'support/fixture_file'
require 'support/src_image_skip_callbacks'

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
      get(:index, params: { q: 'test query', page: '7', format: :json })
    end

    it 'sets the image url on each src image' do
      allow(SrcImage).to receive(:for_user).with(user, nil, nil).and_return(
        src_images
      )
      expect(src_image1).to receive(:'image_url=').with(
        "http://test.host/src_images/#{src_image1.id_hash}.jpg"
      )
      expect(src_image2).to receive(:'image_url=').with(
        "http://test.host/src_images/#{src_image2.id_hash}.jpg"
      )
      expect(src_image3).to receive(:'image_url=').with(
        "http://test.host/src_images/#{src_image3.id_hash}.jpg"
      )
      get(:index, format: :json)
    end

    it 'returns the src images as JSON' do
      allow(SrcImage).to receive(:for_user).with(user, nil, nil).and_return(
        src_images
      )
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
              '%Y-%m-%dT%H:%M:%S.%LZ'
            ),
            'updated_at' => src_image1.updated_at.strftime(
              '%Y-%m-%dT%H:%M:%S.%LZ'
            ),
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
              '%Y-%m-%dT%H:%M:%S.%LZ'
            ),
            'updated_at' => src_image2.updated_at.strftime(
              '%Y-%m-%dT%H:%M:%S.%LZ'
            ),
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
              '%Y-%m-%dT%H:%M:%S.%LZ'
            ),
            'updated_at' => src_image3.updated_at.strftime(
              '%Y-%m-%dT%H:%M:%S.%LZ'
            ),
            'name' => 'src image 3',
            'image_url' =>
        "http://test.host/src_images/#{src_image3.id_hash}.jpg"
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
    before { request.accept = 'application/json' }

    context 'with valid attributes' do
      context 'when uploading image data' do
        it 'creates a src image with the image data' do
          post(:create, params: {
                 src_image: {
                   image: fixture_file_upload(
                     '/files/ti_duck.jpg', 'image/jpeg'
                   )
                 }
               })
          expect(response).to have_http_status(:ok)
          expected_image_data = fixture_file_data('ti_duck.jpg')

          expect(SrcImage.last.image).to eq(expected_image_data)
        end

        it 'increments the src image upload statsd counter' do
          expect do
            post(:create, params: {
                   src_image: {
                     image: fixture_file_upload(
                       '/files/ti_duck.jpg', 'image/jpeg'
                     )
                   }
                 })
            expect(response).to have_http_status(:ok)
          end.to trigger_statsd_increment('src_image.upload')
        end

        it 'sets the creator_ip to the remote ip address' do
          post(:create, params: {
                 src_image: {
                   image: fixture_file_upload(
                     '/files/ti_duck.jpg', 'image/jpeg'
                   )
                 }
               })
          expect(SrcImage.last.creator_ip).to eq('0.0.0.0')
        end

        context 'when the request has a CloudFlare IP header' do
          before { request.headers['CF-Connecting-IP'] = '6.6.2.2' }

          it 'sets the creator_ip to the value of CF-Connecting-IP' do
            post(:create, params: {
                   src_image: {
                     image: fixture_file_upload(
                       '/files/ti_duck.jpg', 'image/jpeg'
                     )
                   }
                 })
            expect(SrcImage.last.creator_ip).to eq('6.6.2.2')
          end
        end
      end

      context 'when loading an image url' do
        it 'creates a src image with the url' do
          post(:create, params: {
                 src_image: {
                   url: 'http://test.com/image.jpg'
                 }
               })
          expect(response).to have_http_status(:ok)
          expect(SrcImage.last.url).to eq('http://test.com/image.jpg')
        end

        it 'does not increment the src image upload statsd counter' do
          expect do
            post(:create, params: {
                   src_image: {
                     url: 'http://test.com/image.jpg'
                   }
                 })
            expect(response).to have_http_status(:ok)
          end.to_not trigger_statsd_increment('src_image.upload')
        end
      end

      it 'creates the src image with the private flag' do
        post(:create, params: {
               src_image: {
                 url: 'http://test.com/image.jpg',
                 private: true
               }
             })
        expect(response).to have_http_status(:ok)
        expect(SrcImage.last.private).to eq(true)
      end

      it 'creates the src image with the name' do
        post(:create, params: {
               src_image: {
                 url: 'http://test.com/image.jpg',
                 name: 'test name'
               }
             })
        expect(response).to have_http_status(:ok)
        expect(SrcImage.last.name).to eq('test name')
      end

      it 'creates the src image owned by the current user' do
        post(:create, params: {
               src_image: {
                 url: 'http://test.com/image.jpg'
               }
             })
        expect(response).to have_http_status(:ok)
        expect(SrcImage.last.user).to eq(user)
      end

      it 'returns ok' do
        post(:create, params: {
               src_image: {
                 url: 'http://test.com/image.jpg'
               }
             })
        expect(response).to have_http_status(:ok)
      end

      it 'returns json with the src image id' do
        post(:create, params: {
               src_image: {
                 url: 'http://test.com/image.jpg'
               }
             })
        expect(response).to have_http_status(:ok)
        created_src_image = SrcImage.last
        expect(JSON.parse(response.body)).to include(
          'id' => created_src_image.id_hash
        )
      end

      it 'returns json with the status url' do
        post(:create, params: {
               src_image: {
                 url: 'http://test.com/image.jpg'
               }
             })
        expect(response).to have_http_status(:ok)
        created_src_image = SrcImage.last
        expect(JSON.parse(response.body)).to include(
          'status_url' =>
            'http://test.host/api/v3/pending_src_images/' \
            "#{created_src_image.id_hash}"
        )
      end
    end

    context 'with invalid attributes' do
      it 'returns unprocessable entity' do
        post(:create, params: { src_image: { name: 'test name' } })
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns json with the errors' do
        post(:create, params: { src_image: { name: 'test name' } })
        expect(JSON.parse(response.body)).to eq(
          'image' => ['is required if url or image external key and bucket ' \
                      'are not set.']
        )
      end
    end
  end

  describe "PUT 'update'" do
    before do
      request.accept = 'application/json'
      request.content_type = 'application/json'
    end

    context 'when the user is not logged in' do
      let(:user) { nil }
      let(:src_image) { FactoryGirl.create(:finished_src_image) }

      it 'returns forbidden' do
        put(:update, params: { id: src_image.id_hash })

        expect(response).to be_forbidden
      end
    end

    context 'when the user does not own the image' do
      let(:src_image) do
        FactoryGirl.create(
          :finished_src_image,
          user: FactoryGirl.create(:user)
        )
      end

      context 'when the user is not an admin' do
        it 'returns forbidden' do
          put(:update, params: {
                id: src_image.id_hash,
                captions_attributes: [
                  { top_left_x_pct: 0.01 }
                ]
              })

          expect(response).to be_forbidden
        end
      end

      context 'when the user is an admin' do
        let(:user) { FactoryGirl.create(:admin_user) }

        it 'updates the image' do
          put(:update, params: {
                id: src_image.id_hash,
                captions_attributes: [
                  {
                    top_left_x_pct: '0.01',
                    top_left_y_pct: '0.02',
                    width_pct: '0.03',
                    height_pct: '0.04',
                    text: 'test'
                  }
                ]
              })

          expect(response).to have_http_status(204)
          expect(src_image.captions.size).to eq(1)

          caption = src_image.captions[0]
          expect(caption.top_left_x_pct).to eq(0.01)
          expect(caption.top_left_y_pct).to eq(0.02)
          expect(caption.width_pct).to eq(0.03)
          expect(caption.height_pct).to eq(0.04)
          expect(caption.text).to eq('test')
        end
      end
    end

    context 'when the user owns the image' do
      let(:src_image) { FactoryGirl.create(:finished_src_image, user: user) }

      it 'updates the image' do
        put(:update, params: {
              id: src_image.id_hash,
              captions_attributes: [
                {
                  top_left_x_pct: '0.01',
                  top_left_y_pct: '0.02',
                  width_pct: '0.03',
                  height_pct: '0.04',
                  text: 'test'
                },
                {
                  top_left_x_pct: '0.05',
                  top_left_y_pct: '0.06',
                  width_pct: '0.07',
                  height_pct: '0.08',
                  text: 'test 2'
                }
              ]
            })

        expect(response).to have_http_status(204)
        expect(src_image.captions.size).to eq(2)

        caption1 = src_image.captions[0]
        expect(caption1.top_left_x_pct).to eq(0.01)
        expect(caption1.top_left_y_pct).to eq(0.02)
        expect(caption1.width_pct).to eq(0.03)
        expect(caption1.height_pct).to eq(0.04)
        expect(caption1.text).to eq('test')

        caption2 = src_image.captions[1]
        expect(caption2.top_left_x_pct).to eq(0.05)
        expect(caption2.top_left_y_pct).to eq(0.06)
        expect(caption2.width_pct).to eq(0.07)
        expect(caption2.height_pct).to eq(0.08)
        expect(caption2.text).to eq('test 2')
      end
    end

    context 'with invalid attributes' do
      let(:src_image) { FactoryGirl.create(:finished_src_image, user: user) }

      it 'returns unprocessable entity with errors' do
        put(:update, params: {
              id: src_image.id_hash,
              captions_attributes: [
                {
                  top_left_x_pct: '0.01',
                  top_left_y_pct: '0.02',
                  width_pct: '0.03',
                  text: 'test'
                }
              ]
            })

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq(
          'captions.height_pct' => ["can't be blank"]
        )
      end
    end
  end
end
