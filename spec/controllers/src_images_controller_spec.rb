# encoding: UTF-8

require 'rails_helper'

describe SrcImagesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user, email: 'user2@user2.com') }

  before(:each) do
    session[:user_id] = user.try(:id)
  end

  describe "GET 'new'" do
    context 'when the user is logged in' do
      it 'returns http success' do
        get :new
        expect(response).to be_success
      end
    end

    context 'when the user it not logged in' do
      let(:user) { nil }
      it 'redirects to the login form' do
        get :new
        expect(response).to redirect_to new_session_path
      end
    end
  end

  describe "GET 'index'" do
    it 'returns http success' do
      get :index

      expect(response).to be_success
    end

    it 'shows the images sorted by reverse gend image count' do
      si1 = FactoryGirl.create(:src_image,
                               user: user,
                               gend_images_count: 20,
                               work_in_progress: false)
      si2 = FactoryGirl.create(:src_image,
                               user: user,
                               gend_images_count: 10,
                               work_in_progress: false)
      si3 = FactoryGirl.create(:src_image,
                               user: user,
                               gend_images_count: 30,
                               work_in_progress: false)

      get :index

      expect(assigns(:src_images)).to eq [si3, si1, si2]
    end

    it 'does not show deleted images' do
      FactoryGirl.create(:src_image, user: user, work_in_progress: false)
      FactoryGirl.create(
        :src_image, user: user, is_deleted: true, work_in_progress: false)

      get :index

      expect(assigns(:src_images).size).to eq 1
    end

    it 'does not show work in progress images' do
      FactoryGirl.create(:src_image, user: user)
      FactoryGirl.create(:src_image, user: user, work_in_progress: false)

      get :index

      expect(assigns(:src_images).size).to eq 1
    end

    it 'shows public images' do
      FactoryGirl.create(:src_image, private: true, work_in_progress: false)
      3.times { FactoryGirl.create(:src_image, work_in_progress: false) }

      get :index

      expect(assigns(:src_images).size).to eq 3
    end

    context 'searching' do
      it 'filters the result by the query string' do
        FactoryGirl.create(
          :src_image, user: user, name: 'abc', work_in_progress: false)
        si2 = FactoryGirl.create(
          :src_image, user: user, name: 'def', work_in_progress: false)
        FactoryGirl.create(
          :src_image, user: user, name: 'ghi', work_in_progress: false)

        get :index, q: 'e'
        expect(assigns(:src_images)).to eq [si2]
      end

      it 'is case insensitive' do
        si = FactoryGirl.create(
          :src_image, user: user, name: 'a', work_in_progress: false)

        get :index, q: 'A'
        expect(assigns(:src_images)).to eq [si]
      end

      it 'ignores leading whitespace' do
        si = FactoryGirl.create(
          :src_image, user: user, name: 'abc', work_in_progress: false)
        get :index, q: " \t\r\nb"
        expect(assigns(:src_images)).to eq([si])
      end

      it 'ignores trailing whitespace' do
        si = FactoryGirl.create(
          :src_image, user: user, name: 'abc', work_in_progress: false)
        get :index, q: "b \t\n\r"
        expect(assigns(:src_images)).to eq([si])
      end
    end

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
      it 'saves the new source image to the database' do
        expect do
          post :create, src_image: { image: image }
        end.to change { SrcImage.count }.by(1)
      end

      it 'redirects to the index page' do
        post :create, src_image: { image: image }

        expect(response).to redirect_to controller: :my, action: :show
      end

      it 'informs the user of success with flash' do
        post :create, src_image: { image: image }

        expect(flash[:notice]).to eq('Source image created.')
      end
    end

    context 'with invalid attributes' do
      let(:image) { nil }

      it 'does not save the new source image in the database' do
        expect do
          post :create, src_image: { image: image }
        end.to_not change { SrcImage.count }
      end

      it 're-renders the new template' do
        post :create, src_image: { image: image }

        expect(response).to render_template('new')
      end
    end

    context 'when the user it not logged in' do
      let(:user) { nil }

      it 'saves the new source image to the database' do
        expect do
          post :create, src_image: { image: image }
        end.to change { SrcImage.count }.by(1)
      end
    end

    context 'setting an optional name' do
      it 'saves the name to the database' do
        post :create, src_image: { image: image, name: 'a test name' }
        expect(SrcImage.last.name).to eq 'a test name'
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
  end

  describe "DELETE 'destroy'" do
    context 'when the id is found' do
      it 'marks the record as deleted in the database' do
        post :create, src_image: {
          image: fixture_file_upload('/files/ti_duck.jpg', 'image/jpeg') }
        delete :destroy, id: assigns(:src_image).id_hash

        expect(SrcImage.find_by(
          id_hash: assigns(:src_image).id_hash).is_deleted?).to eq(true)
      end

      it 'returns success' do
        post :create, src_image: {
          image: fixture_file_upload('/files/ti_duck.jpg', 'image/jpeg') }
        delete :destroy, id: assigns(:src_image).id_hash

        expect(response).to be_success
      end
    end

    context 'when the id is not found' do
      it 'raises record not found' do
        expect do
          delete :destroy, id: 'abc'
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the image is owned by another user' do
      it "doesn't allow it to be deleted" do
        src_image = FactoryGirl.create(:src_image, user: user2)

        delete :destroy, id: src_image.id_hash

        expect(response).to be_forbidden
      end
    end
  end
end
