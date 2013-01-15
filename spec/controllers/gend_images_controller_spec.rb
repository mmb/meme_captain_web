require 'spec_helper'

describe GendImagesController do

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user, :email => 'user2@user2.com') }

  let(:src_image) {
    mock_model(SrcImage, FactoryGirl.attributes_for(:src_image))
  }

  describe "GET 'new'" do

    it "returns http success" do
      SrcImage.should_receive(:find_by_id_hash!).with('abc').and_return(
          src_image)
      get 'new', :src => 'abc'
      expect(response).to be_success
    end
  end

  describe "GET 'index'" do

    let(:src_image) { FactoryGirl.create(:src_image, :user => user) }

    before(:each) do
      controller.stub(:current_user => user)
    end

    subject {
      get :index
    }

    it "returns http success" do
      subject

      expect(response).to be_success
    end

    it 'shows the images sorted by reverse updated time' do
      3.times { FactoryGirl.create(:gend_image, :src_image => src_image) }

      subject

      gend_images = assigns(:gend_images)

      expect(
          gend_images[0].updated_at >= gend_images[1].updated_at &&
              gend_images[1].updated_at >= gend_images[2].updated_at).to be_true
    end

    it 'does not show deleted images' do
      FactoryGirl.create(:gend_image, :src_image => src_image)
      FactoryGirl.create(:gend_image, :src_image => src_image, :is_deleted => true)

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
               gend_image: {:src_image_id => 'abc'},
               :text1 => 'hello',
               :text2 => 'world'
        }.to change { GendImage.count }.by(1)
      end

      it 'redirects to the index' do
        post :create,
             gend_image: {:src_image_id => 'abc'},
             :text1 => 'hello',
             :text2 => 'world'

        expect(response).to redirect_to :action => :index
      end

    end

    context 'when the source image is not found' do

      it 'raises record not found' do
        expect {
          post :create, gend_image: {:src_image_id => 'abc'}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

  describe "GET 'show'" do

    context 'when the id is found' do

      let(:gend_image) { mock_model(GendImage) }

      before :each do
        GendImage.should_receive(:find_by_id_hash!).and_return(gend_image)
      end

      it 'shows the source image' do
        get 'show', :id => 'abc'

        expect(response).to be_success
      end

      it 'has the right content type' do
        gend_image.should_receive(:content_type).and_return('content type')

        get 'show', :id => 'abc'

        expect(response.content_type).to eq('content type')
      end

      it 'has the right content' do
        gend_image.should_receive(:image).and_return('image')

        get 'show', :id => 'abc'

        expect(response.body).to eq('image')
      end

    end

    context 'when the id is not found' do

      it 'raises record not found' do
        expect {
          get 'show', :id => 'abc'
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

  describe "DELETE 'destroy'" do

    let(:src_image) { FactoryGirl.create(:src_image, :user => user) }
    let(:src_image2) { FactoryGirl.create(:src_image, :user => user2) }

    before(:each) do
      controller.stub(:current_user => user)
    end

    context 'when the id is found' do

      let(:gend_image) { FactoryGirl.create(:gend_image, :src_image => src_image) }

      subject {
        delete :destroy, :id => gend_image.id_hash
      }

      it 'marks the record as deleted in the database' do
        subject

        expect {
          GendImage.find_by_id_hash!(gend_image.id_hash).is_deleted?
        }.to be_true
      end

      it 'redirects to the index page' do
        subject
        expect(response).to redirect_to :action => :index
      end

    end

    context 'when the id is not found' do

      it 'raises record not found' do
        expect {
          delete :destroy, :id => 'abc'
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context 'when the image is owned by another user' do

      it "doesn't allow it to be deleted" do
        gend_image = FactoryGirl.create(:gend_image, :src_image => src_image2)

        delete :destroy, :id => gend_image.id_hash

        expect(response).to be_forbidden
      end

    end

  end

end
