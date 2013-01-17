require 'spec_helper'

describe SrcSetsController do

  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    controller.stub(:current_user => user)
  end

  describe "GET 'new'" do

    subject { get 'new' }

    it "returns http success" do
      subject
      expect(response).to be_success
    end
  end

  describe "POST 'create'" do

    context 'with valid attributes' do

      subject { post :create, :src_set => {:name => 'test'} }

      it 'saves the new src set to the database' do
        expect { subject }.to change { SrcSet.count }.by(1)
      end

      it 'redirects to the index' do
        subject

        expect(response).to redirect_to :action => :index
      end

      it 'informs the user of success with flash' do
        subject

        expect(flash[:notice]).to eq('Source set created.')
      end

    end

    context 'with invalid attributes' do

      subject { post :create, :src_set => {} }

      it 'renders the form again' do
        subject
        expect(response).to render_template(:new)
      end

    end

  end

  describe "GET 'index'" do

    subject { get :index }

    it "returns http success" do
      subject

      expect(response).to be_success
    end

    it "shows the user's src sets sorted by reverse updated time" do
      3.times { FactoryGirl.create(:src_set, :user => user) }

      subject

      src_sets = assigns(:src_sets)

      expect(
          src_sets[0].updated_at >= src_sets[1].updated_at &&
              src_sets[1].updated_at >= src_sets[2].updated_at).to be_true
    end

    it 'does not show deleted src sets' do
      FactoryGirl.create(:src_set, :user => user)

      FactoryGirl.create(:src_set, :user => user, :is_deleted => true)

      subject

      expect(assigns(:src_sets).size).to eq 1
    end

  end

  describe "PUT 'update'" do

    let(:src_image) { FactoryGirl.create(:src_image) }
    let(:src_image2) { FactoryGirl.create(:src_image) }
    let(:src_set) { FactoryGirl.create(:src_set) }

    context 'adding source images' do

      subject { put :update, :id => src_set.id, :add_src_images => [src_image.id, src_image2.id] }

      it 'adds source images to the set' do
        expect {
          subject
          src_set.reload
        }.to change { src_set.src_images.size }.by(2)
      end

    end

    context 'deleting source images' do

      subject { put :update, :id => src_set.id, :delete_src_images => [src_image.id, src_image2.id] }

      it 'deletes source images from the set' do
        put :update, :id => src_set.id, :add_src_images => [src_image.id, src_image2.id]

        expect {
          subject
          src_set.reload
        }.to change { src_set.src_images.size }.by(-2)
      end

    end

    context 'changing the name' do

      subject {
        put :update, :id => src_set.id, :src_set => {:name => 'newname'}
        src_set.reload
      }

      its(:name) { should == 'newname' }

    end
  end

end