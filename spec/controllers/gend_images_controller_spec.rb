require 'spec_helper'

describe GendImagesController do

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user, :email => 'user2@user2.com') }
  let(:src_image2) { FactoryGirl.create(:src_image, :user => user2) }

  let(:src_image) {
    mock_model(SrcImage, FactoryGirl.attributes_for(:src_image))
  }

  before(:each) do
    controller.stub(:current_user => user)
  end

  describe "GET 'new'" do

    let(:src_id) { 'abc' }
    subject { get :new, :src => src_id }

    it "returns http success" do
      SrcImage.should_receive(:find_by_id_hash!).with('abc').and_return(
          src_image)
      subject
      expect(response).to be_success
    end

    context 'when the user is not logged in' do

      let(:user) { nil }

      it 'returns http success' do
        SrcImage.should_receive(:find_by_id_hash!).with('abc').and_return(
            src_image)
        subject
        expect(response).to be_success
      end

    end

  end

  describe "GET 'index'" do

    let(:src_image) { FactoryGirl.create(:src_image, :user => user) }

    subject {
      get :index
    }

    it "returns http success" do
      subject

      expect(response).to be_success
    end

    it 'shows the images sorted by reverse updated time' do
      3.times { FactoryGirl.create(:gend_image, :user => user) }

      subject

      gend_images = assigns(:gend_images)

      expect(
          gend_images[0].updated_at >= gend_images[1].updated_at &&
              gend_images[1].updated_at >= gend_images[2].updated_at).to be_true
    end

    it 'does not show deleted images' do
      FactoryGirl.create(:gend_image, :user => user)
      FactoryGirl.create(:gend_image, :user => user, :is_deleted => true)

      subject

      expect(assigns(:gend_images).size).to eq 1
    end

    it 'shows public images' do
      3.times { FactoryGirl.create(:gend_image, :user => user, :private => false) }

      subject

      expect(assigns(:gend_images).size).to eq 3
    end

    it 'does not show private images' do
      FactoryGirl.create(:gend_image, :user => user, :private => false)
      2.times { FactoryGirl.create(:gend_image, :user => user, :private => true) }

      subject

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
        expect {
          post :create,
               gend_image: { :src_image_id => 'abc' },
               :text1 => 'hello',
               :text2 => 'world'
        }.to change { GendImage.count }.by(1)
      end

      it 'redirects to the index' do
        post :create,
             gend_image: { :src_image_id => 'abc' },
             :text1 => 'hello',
             :text2 => 'world'

        expect(response).to redirect_to :controller => :gend_image_pages, :action => :show,
                                        :id => assigns(:gend_image).id_hash
      end

    end

    context 'when the source image is not found' do

      it 'raises record not found' do
        expect {
          post :create, gend_image: { :src_image_id => 'abc' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context 'when the source image is owned by another user' do

      specify 'the gend image is owned by the current user' do
        gend_image = FactoryGirl.create(:gend_image, :src_image => src_image2)

        post :create, gend_image: { :src_image_id => src_image2.id_hash }
        expect(GendImage.last.user).to eq user
      end

    end

  end

  describe "GET 'show'" do

    let(:id) { 'abc' }
    let(:caption1) { mock_model(Caption, :text => '1&2') }
    let(:caption2) { mock_model(Caption, :text => "3\n4") }

    subject { get :show, :id => id }

    context 'when the id is found' do

      let(:captions) { [caption1, caption2] }
      let(:name) { 'name' }
      let(:src_id_hash) { 'test_hash' }
      let(:src_image) { mock_model(SrcImage, id_hash: src_id_hash, name: name) }
      let(:gend_image) { mock_model(GendImage, captions: captions, src_image: src_image) }

      before :each do
        GendImage.should_receive(:find_by_id_hash!).and_return(gend_image)
      end

      it 'shows the source image' do
        subject

        expect(response).to be_success
      end

      it 'has the right content type' do
        gend_image.should_receive(:content_type).and_return('content type')

        subject

        expect(response.content_type).to eq 'content type'
      end

      it 'has the right content' do
        gend_image.should_receive(:image).and_return('image')

        subject

        expect(response.body).to eq 'image'
      end

      context 'returning the meme text in the headers' do

        context 'when there is more than one caption' do
          it 'returns the correct header' do
            subject

            expect(response.headers['Meme-Text']).to eq '1%262&3%0A4'
          end
        end

        context 'when there is one caption' do
          let(:captions) { [caption1] }

          it 'returns the correct header' do
            subject

            expect(response.headers['Meme-Text']).to eq '1%262'
          end
        end

      end

      context 'returning the meme name in the headers' do
        it 'returns the correct header' do
          subject

          expect(response.headers['Meme-Name']).to eq name
        end

        context 'when the name is nil' do
          let(:name) { nil }

          it 'returns nil' do
            subject

            expect(response.headers['Meme-Name']).to be_nil
          end
        end

        context 'when the name has special characters' do
          let(:name) { "a\r\nb" }

          it 'url encodes special characters' do
            subject

            expect(response.headers['Meme-Name']).to eq 'a%0D%0Ab'
          end
        end
      end

      it 'returns the meme src image url in the headers' do
        subject

        expect(response.headers['Meme-Source-Image']).to eq "http://#{request.host}/src_images/#{src_id_hash}"
      end

    end

    context 'when the id is not found' do

      it 'raises record not found' do
        expect {
          subject
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

  describe "DELETE 'destroy'" do

    let(:gend_image) { FactoryGirl.create(:gend_image, :user => user) }
    let(:id) { gend_image.id_hash }

    subject { delete :destroy, :id => id }

    context 'when the id is found' do

      it 'marks the record as deleted in the database' do
        subject

        expect {
          GendImage.find_by_id_hash!(gend_image.id_hash).is_deleted?
        }.to be_true
      end

      it 'returns success' do
        subject
        expect(response).to be_success
      end

    end

    context 'when the id is not found' do

      let(:id) { 'abc' }
      it 'raises record not found' do
        expect {
          subject
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context 'when the image is owned by another user' do
      let(:gend_image) { FactoryGirl.create(:gend_image, :user => user2) }

      it "doesn't allow it to be deleted" do
        subject

        expect(response).to be_forbidden
      end

    end

    context 'when the image is not owned by any user' do
      let(:user) { nil }

      it 'cannot be deleted' do
        subject

        expect(response).to be_forbidden
      end

    end

  end

end
