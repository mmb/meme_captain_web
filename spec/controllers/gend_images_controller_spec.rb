# encoding: UTF-8

require 'spec_helper'

describe GendImagesController do

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user, email: 'user2@user2.com') }
  let(:src_image) { FactoryGirl.create(:src_image, user: user) }
  let(:src_image2) { FactoryGirl.create(:src_image, user: user2) }

  before(:each) do
    session[:user_id] = user.try(:id)
  end

  describe "GET 'new'" do

    let(:src_id) { 'abc' }

    it 'returns http success' do
      SrcImage.should_receive(:find_by_id_hash!).with('abc').and_return(
          src_image)
      get :new, src: src_id
      expect(response).to be_success
    end

    context 'when the user is not logged in' do

      let(:user) { nil }

      it 'returns http success' do
        SrcImage.should_receive(:find_by_id_hash!).with('abc').and_return(
            src_image)
        get :new, src: src_id
        expect(response).to be_success
      end

    end

  end

  describe "GET 'index'" do

    it 'returns http success' do
      get :index

      expect(response).to be_success
    end

    it 'shows the images sorted by reverse updated time' do
      3.times { FactoryGirl.create(:gend_image, user: user) }

      get :index

      gend_images = assigns(:gend_images)

      expect(
          gend_images[0].updated_at >= gend_images[1].updated_at &&
              gend_images[1].updated_at >= gend_images[2].updated_at
      ).to be(true)
    end

    it 'does not show deleted images' do
      FactoryGirl.create(:gend_image, user: user)
      FactoryGirl.create(:gend_image, user: user, is_deleted: true)

      get :index

      expect(assigns(:gend_images).size).to eq 1
    end

    it 'shows public images' do
      3.times { FactoryGirl.create(:gend_image, user: user, private: false) }

      get :index

      expect(assigns(:gend_images).size).to eq 3
    end

    it 'does not show private images' do
      FactoryGirl.create(:gend_image, user: user, private: false)
      2.times { FactoryGirl.create(:gend_image, user: user, private: true) }

      get :index

      expect(assigns(:gend_images).size).to eq 1
    end

  end

  describe "POST 'create'" do

    context 'with valid attributes' do

      before :each do
        SrcImage.should_receive(:find_by_id_hash!).with('abc').and_return(
            src_image)
      end

      it 'saves the new generated image to the database' do
        expect do
          post :create,
               gend_image: {
                   src_image_id: 'abc',
                   captions_attributes: {
                       '0' => {
                           'font' => 'font1',
                           'text' => 'hello',
                           'top_left_x_pct' => '0.01',
                           'top_left_y_pct' => '0.02',
                           'width_pct' => '0.03',
                           'height_pct' => '0.04',
                       },
                       '1' => {
                           'font' => 'font2',
                           'text' => 'world',
                           'top_left_x_pct' => '0.05',
                           'top_left_y_pct' => '0.06',
                           'width_pct' => '0.07',
                           'height_pct' => '0.08',
                       },
                       '2' => {
                           'font' => 'font3',
                           'text' => '!',
                           'top_left_x_pct' => '0.09',
                           'top_left_y_pct' => '0.10',
                           'width_pct' => '0.11',
                           'height_pct' => '0.12',
                       },
                   },
                   private: '1'
               }
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

        expect(created.private).to be_true
      end

      it 'redirects to the index' do
        post :create,
             gend_image: { src_image_id: 'abc' }

        expect(response).to redirect_to(
                                controller: :gend_image_pages,
                                action: :show,
                                id: assigns(:gend_image).id_hash)
      end

    end

    context 'when the source image is not found' do

      it 'raises record not found' do
        expect do
          post :create, gend_image: { src_image_id: 'abc' }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context 'when the source image is owned by another user' do

      specify 'the gend image is owned by the current user' do
        FactoryGirl.create(:gend_image, src_image: src_image2)

        post :create, gend_image: { src_image_id: src_image2.id_hash }
        expect(GendImage.last.user).to eq user
      end

    end

  end

  describe "GET 'show'" do

    let(:id) { 'abc' }
    let(:caption1) { mock_model(Caption, text: '1&2') }
    let(:caption2) { mock_model(Caption, text: "3\n4") }

    context 'when the id is found' do

      let(:captions) { [caption1, caption2] }
      let(:name) { 'name' }
      let(:src_id_hash) { 'test_hash' }
      let(:src_image) do
        mock_model(SrcImage, id_hash: src_id_hash, name: name)
      end
      let(:gend_image) do
        mock_model(GendImage, captions: captions, src_image: src_image)
      end

      before do
        GendImage.should_receive(:find_by_id_hash_and_is_deleted!).and_return(gend_image)
      end

      it 'shows the source image' do
        get :show, id: id

        expect(response).to be_success
      end

      it 'has the right content type' do
        gend_image.should_receive(:content_type).and_return('content type')

        get :show, id: id

        expect(response.content_type).to eq 'content type'
      end

      it 'has the right content' do
        gend_image.should_receive(:image).and_return('image')

        get :show, id: id

        expect(response.body).to eq 'image'
      end

      context 'returning the meme text in the headers' do

        context 'when there is more than one caption' do
          it 'returns the correct header' do
            get :show, id: id

            expect(response.headers['Meme-Text']).to eq '1%262&3%0A4'
          end
        end

        context 'when there is one caption' do
          let(:captions) { [caption1] }

          it 'returns the correct header' do
            get :show, id: id

            expect(response.headers['Meme-Text']).to eq '1%262'
          end
        end

      end

      context 'returning the meme name in the headers' do
        it 'returns the correct header' do
          get :show, id: id

          expect(response.headers['Meme-Name']).to eq name
        end

        context 'when the name is nil' do
          let(:name) { nil }

          it 'returns nil' do
            get :show, id: id

            expect(response.headers['Meme-Name']).to be_nil
          end
        end

        context 'when the name has special characters' do
          let(:name) { "a\r\nb" }

          it 'url encodes special characters' do
            get :show, id: id

            expect(response.headers['Meme-Name']).to eq 'a%0D%0Ab'
          end
        end
      end

      it 'returns the meme src image url in the headers' do
        get :show, id: id

        expected_url = "http://#{request.host}/src_images/#{src_id_hash}"
        expect(response.headers['Meme-Source-Image']).to eq(expected_url)
      end

      it 'has the correct Cache-Control headers' do
        get :show, id: id

        expect(response.headers['Cache-Control']).to eq 'max-age=86400, public'
      end

    end

    context 'when the id is not found' do

      it 'raises record not found' do
        expect { get :show, id: id }.to raise_error(
                                            ActiveRecord::RecordNotFound)
      end

    end

    context 'when the image has been deleted' do
      let(:gend_image) { FactoryGirl.create(:gend_image, is_deleted: true) }

      it 'raises record not found' do
        expect { get :show, id: gend_image.id_hash }.to raise_error(
                                                            ActiveRecord::RecordNotFound)
      end
    end

  end

  describe "DELETE 'destroy'" do

    let(:gend_image) { FactoryGirl.create(:gend_image, user: user) }
    let(:id) { gend_image.id_hash }

    context 'when the id is found' do

      it 'marks the record as deleted in the database' do
        delete :destroy, id: id

        expect do
          GendImage.find_by_id_hash!(gend_image.id_hash).is_deleted?
        end.to be_true
      end

      it 'returns success' do
        delete :destroy, id: id
        expect(response).to be_success
      end

    end

    context 'when the id is not found' do

      let(:id) { 'abc' }
      it 'raises record not found' do
        expect { delete :destroy, id: id }.to raise_error(
                                                  ActiveRecord::RecordNotFound)
      end

    end

    context 'when the image is owned by another user' do
      let(:gend_image) { FactoryGirl.create(:gend_image, user: user2) }

      it "doesn't allow it to be deleted" do
        delete :destroy, id: id

        expect(response).to be_forbidden
      end

    end

    context 'when the image is not owned by any user' do
      let(:user) { nil }

      it 'cannot be deleted' do
        delete :destroy, id: id

        expect(response).to be_forbidden
      end

    end

  end

end
