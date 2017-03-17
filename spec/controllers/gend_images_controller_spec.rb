require 'rails_helper'

require 'support/gend_image_skip_callbacks'
require 'support/src_image_skip_callbacks'
require 'support/stop_time'

describe GendImagesController, type: :controller do
  include StatsD::Instrument::Matchers

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user, email: 'user2@user2.com') }
  let(:src_image) do
    FactoryGirl.create(:src_image, user: user, work_in_progress: false)
  end
  let(:src_image2) do
    FactoryGirl.create(:src_image, user: user2, work_in_progress: false)
  end

  before(:each) do
    session[:user_id] = user.try(:id)

    src_image.set_derived_image_fields
    src_image.save!

    src_image2.set_derived_image_fields
    src_image2.save!
  end

  describe "GET 'new'" do
    it 'returns http success' do
      get(:new, params: { src: src_image.id_hash })
      expect(response).to be_success
    end

    context 'when the user is not logged in' do
      let(:user) { nil }

      it 'returns http success' do
        get(:new, params: { src: src_image.id_hash })
        expect(response).to be_success
      end
    end

    it 'assigns the source image path' do
      get(:new, params: { src: src_image.id_hash })
      expect(assigns(:src_image_path)).to eq(
        "http://test.host/src_images/#{src_image.id_hash}"
      )
    end

    it 'assigns the source image url with extension' do
      get(:new, params: { src: src_image.id_hash })
      expect(assigns(:src_image_url_with_extension)).to eq(
        "http://test.host/src_images/#{src_image.id_hash}.jpg"
      )
    end

    it 'assigns a new gend image with the src_image' do
      get(:new, params: { src: src_image.id_hash })
      expect(assigns(:gend_image).src_image).to eq(src_image)
    end

    it 'assigns caption 1' do
      get(:new, params: { src: src_image.id_hash })
      caption = assigns(:gend_image).captions[0]
      expect(caption.top_left_x_pct).to eq(0.05)
      expect(caption.top_left_y_pct).to eq(0)
      expect(caption.width_pct).to eq(0.9)
      expect(caption.height_pct).to eq(0.25)
    end

    it 'assigns caption 2' do
      get(:new, params: { src: src_image.id_hash })
      caption = assigns(:gend_image).captions[1]
      expect(caption.top_left_x_pct).to eq(0.05)
      expect(caption.top_left_y_pct).to eq(0.75)
      expect(caption.width_pct).to eq(0.9)
      expect(caption.height_pct).to eq(0.25)
    end

    context 'when the source image is not private' do
      let(:src_image) do
        FactoryGirl.create(:src_image, user: user, private: false)
      end

      it "sets the new image's private flag to false" do
        get(:new, params: { src: src_image.id_hash })

        expect(assigns(:gend_image).private).to eq(false)
      end
    end

    context 'when the source image is private' do
      let(:src_image) do
        FactoryGirl.create(:src_image, user: user, private: true)
      end

      it "sets the new image's private flag to true" do
        get(:new, params: { src: src_image.id_hash })

        expect(assigns(:gend_image).private).to eq(true)
      end
    end

    context 'when the source image is deleted' do
      let(:src_image) { FactoryGirl.create(:src_image, is_deleted: true) }

      it 'returns not found' do
        expect do
          get(:new, params: { src: src_image.id_hash })
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'setting can_edit_src_image' do
      context 'when the user is an admin' do
        let(:user) { FactoryGirl.create(:admin_user) }

        it 'sets can_edit_src_image to true' do
          get(:new, params: { src: src_image.id_hash })
          expect(assigns(:can_edit_src_image)).to eq(true)
        end
      end

      context 'when the user is not an admin' do
        let(:user) { FactoryGirl.create(:user) }

        context 'when the user owns the src image' do
          let(:src_image) { FactoryGirl.create(:src_image, user: user) }

          it 'sets can_edit_src_image to true' do
            get(:new, params: { src: src_image.id_hash })
            expect(assigns(:can_edit_src_image)).to eq(true)
          end
        end

        context 'when the user does not own the src image' do
          let(:src_image) { FactoryGirl.create(:src_image, user: user2) }

          it 'sets can_edit_src_image to false' do
            get(:new, params: { src: src_image.id_hash })
            expect(assigns(:can_edit_src_image)).to eq(false)
          end
        end
      end

      context 'when the user is not logged in' do
        let(:user) { nil }

        it 'sets can_edit_src_image to false' do
          get(:new, params: { src: src_image.id_hash })
          expect(assigns(:can_edit_src_image)).to eq(false)
        end
      end
    end
  end

  describe "GET 'index'" do
    it 'returns http success' do
      get(:index)

      expect(response).to be_success
    end

    it 'shows the images sorted by reverse updated time' do
      3.times do
        FactoryGirl.create(:gend_image, user: user, work_in_progress: false)
      end

      get(:index)

      gend_images = assigns(:gend_images)

      expect(
        gend_images[0].updated_at >= gend_images[1].updated_at &&
        gend_images[1].updated_at >= gend_images[2].updated_at
      ).to be(true)
    end

    context 'when the user is not an admin' do
      it 'does not show deleted images' do
        FactoryGirl.create(
          :gend_image,
          user: user,
          work_in_progress: false
        )
        FactoryGirl.create(
          :gend_image,
          user: user,
          work_in_progress: false,
          is_deleted: true
        )

        get(:index)

        expect(assigns(:gend_images).size).to eq(1)
      end

      it 'shows public images' do
        3.times do
          FactoryGirl.create(
            :gend_image,
            user: user,
            work_in_progress: false,
            private: false
          )
        end

        get(:index)

        expect(assigns(:gend_images).size).to eq(3)
      end

      it 'does not show private images' do
        FactoryGirl.create(
          :gend_image,
          user: user,
          work_in_progress: false,
          private: false
        )
        2.times do
          FactoryGirl.create(
            :gend_image,
            user: user,
            work_in_progress: false,
            private: true
          )
        end

        get(:index)

        expect(assigns(:gend_images).size).to eq(1)
      end
    end

    context 'when the user is an admin' do
      let(:user) { FactoryGirl.create(:admin_user) }

      it 'shows deleted images' do
        FactoryGirl.create(:gend_image, user: user)
        FactoryGirl.create(:gend_image, user: user, is_deleted: true)

        get(:index)

        expect(assigns(:gend_images).size).to eq(2)
      end

      it 'shows public images' do
        3.times { FactoryGirl.create(:gend_image, user: user, private: false) }

        get(:index)

        expect(assigns(:gend_images).size).to eq(3)
      end

      it 'shows private images' do
        FactoryGirl.create(:gend_image, user: user, private: false)
        2.times { FactoryGirl.create(:gend_image, user: user, private: true) }

        get(:index)

        expect(assigns(:gend_images).size).to eq(3)
      end
    end
  end

  describe "POST 'create'" do
    context 'with valid attributes' do
      it 'saves the new generated image to the database' do
        expect do
          post(:create, params: {
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
               })
        end.to change { GendImage.count }.by(1)

        created = GendImage.last

        expect(created.captions[0].font).to eq 'font1'
        expect(created.captions[0].text).to eq 'hello'
        expect(created.captions[0].top_left_x_pct).to eq 0.01
        expect(created.captions[0].top_left_y_pct).to eq 0.02
        expect(created.captions[0].width_pct).to eq 0.03
        expect(created.captions[0].height_pct).to eq 0.04

        expect(created.captions[1].font).to eq 'font2'
        expect(created.captions[1].text).to eq 'world'
        expect(created.captions[1].top_left_x_pct).to eq 0.05
        expect(created.captions[1].top_left_y_pct).to eq 0.06
        expect(created.captions[1].width_pct).to eq 0.07
        expect(created.captions[1].height_pct).to eq 0.08

        expect(created.captions[2].font).to eq 'font3'
        expect(created.captions[2].text).to eq '!'
        expect(created.captions[2].top_left_x_pct).to eq 0.09
        expect(created.captions[2].top_left_y_pct).to eq 0.10
        expect(created.captions[2].width_pct).to eq 0.11
        expect(created.captions[2].height_pct).to eq 0.12

        expect(created.private).to eq(true)
      end

      it 'does not increment the bot.attempt statsd counter' do
        expect do
          post(:create, params: {
                 gend_image: { src_image_id: src_image.id_hash }
               })
        end.not_to trigger_statsd_increment('bot.attempt')
      end

      it 'sets the creator_ip to the remote ip address' do
        post(:create, params: {
               gend_image: { src_image_id: src_image.id_hash }
             })
        expect(GendImage.last.creator_ip).to eq('0.0.0.0')
      end

      context 'when the request has a CloudFlare IP header' do
        before { request.headers['CF-Connecting-IP'] = '6.6.2.2' }

        it 'sets the creator_ip to the value of CF-Connecting-IP' do
          post(:create, params: {
                 gend_image: { src_image_id: src_image.id_hash }
               })
          expect(GendImage.last.creator_ip).to eq('6.6.2.2')
        end
      end

      context 'when the client requests html' do
        it 'redirects to the gend image page' do
          post(:create, params: {
                 gend_image: { src_image_id: src_image.id_hash }
               })

          expect(response).to redirect_to(
            controller: :gend_image_pages,
            action: :show,
            id: assigns(:gend_image).id_hash
          )
        end
      end

      context 'when the client requests json' do
        before { request.accept = 'application/json' }

        it 'responds with accepted' do
          post(:create, params: {
                 gend_image: { src_image_id: src_image.id_hash }
               })

          expect(response).to have_http_status(:accepted)
        end

        it 'sets the location header to the pending image url' do
          post(:create, params: {
                 gend_image: { src_image_id: src_image.id_hash }
               })

          expect(response.headers['Location']).to eq(
            'http://test.host/pending_gend_images/' \
            "#{assigns(:gend_image).id_hash}"
          )
        end

        it 'returns the status url in the response' do
          post(:create, params: {
                 gend_image: { src_image_id: src_image.id_hash }
               })

          expect(JSON.parse(response.body)['status_url']).to eq(
            'http://test.host/pending_gend_images/' \
            "#{assigns(:gend_image).id_hash}"
          )
        end
      end
    end

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
        }.to_json
      end

      context 'when the client requests json' do
        before do
          request.accept = 'application/json'
          request.content_type = 'application/json'
        end

        it 'returns unprocessable entity status' do
          post(:create, body: body)
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error in the response body' do
          post(:create, body: body)

          expect(JSON.parse(response.body)).to eq(
            'captions.height_pct' => ["can't be blank"]
          )
        end
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
        }.to_json
      end

      context 'when the client requests json' do
        before do
          request.accept = 'application/json'
          request.content_type = 'application/json'
        end

        it 'returns unprocessable entity status' do
          post(:create, body: body)
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error in the response body' do
          post(:create, body: body)

          expect(JSON.parse(response.body)).to eq(
            'captions.top_left_x_pct' => ["can't be blank"]
          )
        end
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
        }.to_json
      end

      context 'when the client requests json' do
        before do
          request.accept = 'application/json'
          request.content_type = 'application/json'
        end

        it 'returns unprocessable entity status' do
          post(:create, body: body)
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error in the response body' do
          post(:create, body: body)

          expect(JSON.parse(response.body)).to eq(
            'captions.top_left_y_pct' => ["can't be blank"]
          )
        end
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
        }.to_json
      end

      context 'when the client requests json' do
        before do
          request.accept = 'application/json'
          request.content_type = 'application/json'
        end

        it 'returns unprocessable entity status' do
          post(:create, body: body)
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error in the response body' do
          post(:create, body: body)

          expect(JSON.parse(response.body)).to eq(
            'captions.width_pct' => ["can't be blank"]
          )
        end
      end
    end

    context 'when the source image is not found' do
      it 'raises record not found' do
        expect do
          post(:create, params: { gend_image: { src_image_id: 'abc' } })
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the source image is still in progress' do
      let(:src_image) { FactoryGirl.create(:src_image, work_in_progress: true) }

      it 'raises record not found' do
        expect do
          post(:create, params: {
                 gend_image: { src_image_id: src_image.id_hash }
               })
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
          post(:create, params: {
                 gend_image: { src_image_id: src_image.id_hash }
               })
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the gend_image parameter is missing' do
      it 'raises record not found' do
        expect do
          post(:create, params: {})
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the source image is owned by another user' do
      specify 'the gend image is owned by the current user' do
        FactoryGirl.create(:gend_image, src_image: src_image2)

        post(:create, params: {
               gend_image: { src_image_id: src_image2.id_hash }
             })
        expect(GendImage.last.user).to eq user
      end
    end

    context 'when an email is passed in' do
      it 'does not save the new gend image to the database' do
        expect do
          post(:create, params: {
                 gend_image: {
                   src_image_id: src_image.id_hash,
                   email: 'not@empty.com'
                 }
               })
        end.to_not change { GendImage.count }
      end

      it 're-renders the new template' do
        post(:create, params: {
               gend_image: {
                 src_image_id: src_image.id_hash,
                 email: 'not@empty.com'
               }
             })

        expect(response).to render_template('new')
      end

      it 'increments the bot.attempt statsd counter' do
        expect do
          post(:create, params: {
                 gend_image: {
                   src_image_id: src_image.id_hash,
                   email: 'not@empty.com'
                 }
               })
        end.to trigger_statsd_increment('bot.attempt')
      end
    end
  end

  describe "GET 'show'" do
    context 'when the id is found' do
      let(:caption1) { FactoryGirl.create(:caption, text: 'caption 1') }
      let(:caption2) { FactoryGirl.create(:caption, text: 'caption 2') }
      let(:captions) { [caption1, caption2] }
      let(:name) { 'meme name' }
      let(:src_image) { FactoryGirl.create(:src_image, name: name) }
      let(:gend_image) do
        FactoryGirl.create(
          :gend_image,
          src_image: src_image,
          captions: captions,
          work_in_progress: false
        )
      end

      it 'shows the gend image' do
        get(:show, params: { id: gend_image.id_hash })

        expect(response).to be_success
      end

      it 'has the right content type' do
        get(:show, params: { id: gend_image.id_hash })

        expect(response.headers['Content-Type']).to eq(gend_image.content_type)
      end

      it 'has the right Content-Length header' do
        get(:show, params: { id: gend_image.id_hash })

        expect(response.headers['Content-Length']).to eq(9141)
      end

      it 'has the right content' do
        get(:show, params: { id: gend_image.id_hash })

        expect(response.body).to eq(gend_image.image)
      end

      context 'returning the meme name in the headers' do
        it 'returns the correct header' do
          get(:show, params: { id: gend_image.id_hash })

          expect(response.headers['Meme-Name']).to eq('meme+name')
        end

        context 'when the name is nil' do
          let(:name) { nil }

          it 'returns nil' do
            get(:show, params: { id: gend_image.id_hash })

            expect(response.headers['Meme-Name']).to eq('')
          end
        end

        context 'when the name has special characters' do
          let(:name) { "a\r\nb" }

          it 'url encodes special characters' do
            get(:show, params: { id: gend_image.id_hash })

            expect(response.headers['Meme-Name']).to eq('a%0D%0Ab')
          end
        end
      end

      context 'returning the meme src image url in the headers' do
        context 'when there is no CDN' do
          before do
            stub_const('MemeCaptainWeb::Config::GEND_IMAGE_HOST', nil)
          end

          it 'uses the image url on the server' do
            get(:show, params: { id: gend_image.id_hash })

            expected_url = \
              "http://#{request.host}/src_images/#{src_image.id_hash}.jpg"
            expect(response.headers['Meme-Source-Image']).to eq(expected_url)
          end
        end

        context 'when there is a CDN' do
          before do
            stub_const('MemeCaptainWeb::Config::GEND_IMAGE_HOST', 'cdn.com')
          end

          it 'uses the image url on the CDN' do
            get(:show, params: { id: gend_image.id_hash })

            expected_url = "http://cdn.com/src_images/#{src_image.id_hash}.jpg"
            expect(response.headers['Meme-Source-Image']).to eq(expected_url)
          end
        end
      end

      it 'has the correct Cache-Control headers' do
        get(:show, params: { id: gend_image.id_hash })

        expect(response.headers['Cache-Control']).to eq(
          'max-age=31557600, public'
        )
      end

      it 'has the correct Expires header' do
        stop_time(Time.parse('feb 8 2010 21:55:00 UTC'))
        get(:show, params: { id: gend_image.id_hash })

        expires_header = response.headers['Expires']
        expect(expires_header).to eq('Tue, 08 Feb 2011 21:55:00 GMT')
      end

      context 'when the image data is in an external object store' do
        let(:gend_image) do
          FactoryGirl.create(
            :finished_gend_image,
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
          get(:show, params: { id: gend_image.id_hash })

          expect(response.body).to eq('data')
        end
      end
    end

    context 'when the id is not found' do
      it 'raises record not found' do
        expect do
          get(:show, params: { id: 'does not exist' })
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the image has been deleted' do
      let(:gend_image) { FactoryGirl.create(:gend_image, is_deleted: true) }

      it 'raises record not found' do
        expect do
          get(:show, params: { id: gend_image.id_hash })
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the image is not finished being processed' do
      let(:gend_image) do
        FactoryGirl.create(:gend_image, work_in_progress: true)
      end

      it 'raises record not found' do
        expect do
          get(:show, params: { id: gend_image.id_hash })
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE 'destroy'" do
    let(:gend_image) { FactoryGirl.create(:gend_image, user: user) }
    let(:id) { gend_image.id_hash }

    context 'when the id is found' do
      it 'marks the record as deleted in the database' do
        delete(:destroy, params: { id: id })
        gend_image.reload
        expect(gend_image.is_deleted?).to eq(true)
      end

      it 'returns success' do
        delete(:destroy, params: { id: id })
        expect(response).to be_success
      end
    end

    context 'when the id is not found' do
      let(:id) { 'abc' }
      it 'raises record not found' do
        expect { delete(:destroy, params: { id: id }) }.to raise_error(
          ActiveRecord::RecordNotFound
        )
      end
    end

    context 'when the image is owned by another user' do
      let(:gend_image) { FactoryGirl.create(:gend_image, user: user2) }

      it "doesn't allow it to be deleted" do
        delete(:destroy, params: { id: id })

        expect(response).to be_forbidden
      end
    end

    context 'when the image is not owned by any user' do
      let(:user) { nil }

      it 'cannot be deleted' do
        delete(:destroy, params: { id: id })

        expect(response).to be_forbidden
      end
    end

    context 'when the user is an admin' do
      let(:user) { FactoryGirl.create(:admin_user) }

      context 'when the image is not owned by any user' do
        let(:gend_image) { FactoryGirl.create(:gend_image) }

        it 'marks the image as deleted' do
          expect { delete(:destroy, params: { id: id }) }.to change {
            gend_image.reload
            gend_image.is_deleted?
          }.from(false).to(true)
        end
      end

      context 'when the image is owned by another user' do
        let(:gend_image) { FactoryGirl.create(:gend_image, user: user2) }

        it 'marks the image as deleted' do
          expect { delete(:destroy, params: { id: id }) }.to change {
            gend_image.reload
            gend_image.is_deleted?
          }.from(false).to(true)
        end
      end
    end
  end
end
