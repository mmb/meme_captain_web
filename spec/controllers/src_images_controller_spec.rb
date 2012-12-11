require 'spec_helper'

describe SrcImagesController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      controller.stub_chain(:current_user, :src_images) { [] }

      get 'index'
      response.should be_success
    end
  end

  describe "POST 'create'" do

    context 'with valid attributes' do

      it 'saves the new source image to the database' do
        expect {
          post :create, src_image: {
            :image => fixture_file_upload('/files/ti_duck.jpg', 'image/jpeg') }
        }.to change{SrcImage.count}.by(1)
      end

      it 'redirects to the index page' do
        post :create, src_image: {
          :image => fixture_file_upload('/files/ti_duck.jpg', 'image/jpeg') }

        response.should redirect_to :action => :index
      end

      it 'informs the user of success with flash' do
        post :create, src_image: {
          :image => fixture_file_upload('/files/ti_duck.jpg', 'image/jpeg') }

        flash[:notice].should == 'Source image created.'
      end

    end

    context 'with invalid attributes' do

      it 'does not save the new source image in the database' do
        expect {
          post :create, src_image: { :image => nil }
        }.to_not change{SrcImage.count}
      end

      it 're-renders the new template' do
        post :create, src_image: { :image => nil }

        response.should render_template('new')
      end

    end

  end

  describe "GET 'show'" do

    context 'when the id is found' do

      let(:src_image) {
        mock_model(SrcImage)
      }

      it 'shows the source image' do
        SrcImage.should_receive(:find).and_return(src_image)

        get 'show', :id => 1

        response.should be_success
      end

      it 'has the right content type' do
        src_image.should_receive(:content_type).and_return('content type')
        SrcImage.should_receive(:find).and_return(src_image)

        get 'show', :id => 1

        response.content_type.should == 'content type'
      end

      it 'has the right content' do
        src_image.should_receive(:image).and_return('image')
        SrcImage.should_receive(:find).and_return(src_image)

        get 'show', :id => 1

        response.body.should == 'image'
      end

    end

    context 'when the id is not found' do

      it 'raises record not found' do
        expect {
          get 'show', :id => 1
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

end
