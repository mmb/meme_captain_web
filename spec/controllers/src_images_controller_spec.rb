require 'spec_helper'

describe SrcImagesController do

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user, :email => 'user2@user2.com') }

  before(:each) do
    controller.stub :current_user => user
  end

  describe "GET 'new'" do

    subject { get :new }

    context 'when the user is logged in' do
      it "returns http success" do
        subject
        expect(response).to be_success
      end
    end

    context 'when the user it not logged in' do
      let(:user) { nil }
      it 'redirects to the login form' do
        subject
        expect(response).to redirect_to new_session_path
      end
    end
  end

  describe "GET 'index'" do

    subject {
      get :index
    }

    it "returns http success" do
      subject

      expect(response).to be_success
    end

    it 'shows the images sorted by reverse updated time' do
      3.times { FactoryGirl.create(:src_image, :user => user) }

      subject

      src_images = assigns(:src_images)

      expect(
          src_images[0].updated_at >= src_images[1].updated_at &&
              src_images[1].updated_at >= src_images[2].updated_at).to be_true
    end

    it 'does not show deleted images' do
      FactoryGirl.create(:src_image, :user => user)
      FactoryGirl.create(:src_image, :user => user, :is_deleted => true)

      subject

      expect(assigns(:src_images).size).to eq 1
    end

    context 'when the user is not logged in' do

      let(:user) { nil }

      it 'redirects to login form' do
        subject
        expect(response).to redirect_to new_session_path
      end

      it 'sets the return to url in the session' do
        subject
        expect(session[:return_to]).to include src_images_path
      end

      it 'informs the user to login' do
        subject
        expect(flash[:notice]).to eq 'Please login to view source images.'
      end

    end

  end

  describe "POST 'create'" do

    let(:image) { fixture_file_upload('/files/ti_duck.jpg', 'image/jpeg') }

    subject { post :create, src_image: {:image => image} }

    context 'with valid attributes' do

      it 'saves the new source image to the database' do
        expect { subject }.to change { SrcImage.count }.by(1)
      end

      it 'redirects to the index page' do
        subject

        expect(response).to redirect_to :action => :index
      end

      it 'informs the user of success with flash' do
        subject

        expect(flash[:notice]).to eq('Source image created.')
      end

    end

    context 'with invalid attributes' do

      let(:image) { nil }

      it 'does not save the new source image in the database' do
        expect { subject }.to_not change { SrcImage.count }
      end

      it 're-renders the new template' do
        subject

        expect(response).to render_template('new')
      end

    end

    context 'when the user it not logged in' do

      let(:user) { nil }

      it 'redirects to the login form' do
        subject

        expect(response).to redirect_to new_session_path
      end
    end

  end

  describe "GET 'show'" do

    context 'when the id is found' do

      let(:src_image) {
        mock_model(SrcImage)
      }

      before :each do
        SrcImage.should_receive(:find_by_id_hash!).and_return(src_image)
      end

      it 'shows the source image' do
        get 'show', :id => 'abc'

        expect(response).to be_success
      end

      it 'has the right content type' do
        src_image.should_receive(:content_type).and_return('content type')

        get 'show', :id => 'abc'

        expect(response.content_type).to eq('content type')
      end

      it 'has the right content' do
        src_image.should_receive(:image).and_return('image')

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

    context 'when the id is found' do

      subject {
        post :create, src_image: {
            :image => fixture_file_upload('/files/ti_duck.jpg', 'image/jpeg')}
        delete :destroy, :id => assigns(:src_image).id_hash
      }

      it 'marks the record as deleted in the database' do
        subject

        expect {
          SrcImage.find_by_id_hash!(assigns(:src_image).id_hash).is_deleted?
        }.to be_true
      end

      it 'returns success' do
        subject
        expect(response).to be_success
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
        src_image = FactoryGirl.create(:src_image, :user => user2)

        delete :destroy, :id => src_image.id_hash

        expect(response).to be_forbidden
      end

    end

  end

end