require 'spec_helper'

describe GendImagesController do

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

    before :each do
      controller.stub_chain(:current_user, :gend_images) { [] }
    end

    subject { get 'index' }

    it 'assigns the images' do
      subject
      expect(assigns(:gend_images)).to eq []
    end

    it "returns http success" do
      subject
      expect(response).to be_success
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

end
