require 'spec_helper'

describe SrcSetsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

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
    let(:src_set) { FactoryGirl.create(:src_set, :user => user) }

    context 'adding source images' do

      subject {
        put :update, :id => src_set.name, :add_src_images => [src_image.id_hash, src_image2.id_hash]
        src_set.reload
      }

      it 'adds source images to the set' do
        expect { subject }.to change { src_set.src_images.size }.by(2)
      end

      it "changes the set's updated time" do
        expect { subject }.to change { src_set.updated_at }
      end

      it 'redirects to the source set' do
        subject
        expect(response).to redirect_to :action => :show
      end

      it 'informs the user of success with a notice' do
        subject
        expect(flash[:notice]).to eq 'The set was successfully updated.'
      end

    end

    context 'deleting source images' do

      subject {
        put :update, :id => src_set.name, :delete_src_images => [src_image.id_hash, src_image2.id_hash]
        src_set.reload
      }

      before(:each) do
        put :update, :id => src_set.name, :add_src_images => [src_image.id_hash, src_image2.id_hash]
      end

      it 'deletes source images from the set' do
        expect { subject }.to change { src_set.src_images.size }.by(-2)
      end

      it "changes the set's updated time" do
        expect { subject }.to change { src_set.updated_at }
      end

      it 'redirects to the source set' do
        subject
        expect(response).to redirect_to :action => :show
      end

      it 'informs the user of success with a notice' do
        subject
        expect(flash[:notice]).to eq 'The set was successfully updated.'
      end

    end

    context 'changing the name' do

      subject {
        put :update, :id => src_set.name, :src_set => {:name => 'newname'}
        src_set.reload
      }

      its(:name) { should == 'newname' }

      it 'redirects to the source set' do
        subject
        expect(response).to redirect_to :action => :show, :id => 'newname'
      end

      it 'informs the user of success with a notice' do
        subject
        expect(flash[:notice]).to eq 'The set was successfully updated.'
      end

    end

    context 'when the source set is owned by another user' do

      it "doesn't allow it to be updated" do
        src_set = FactoryGirl.create(:src_set, :user => user2)

        put :update, :id => src_set.name, :src_set => {:name => 'newname'}

        expect(response).to be_forbidden
      end

    end

    context "when the set doesn't exist" do

      it 'creates the set' do
        expect {
          put :update, :id => 'a new set', :add_src_images => [src_image.id_hash]
        }.to change { SrcSet.count }.by(1)
      end

    end

  end

  describe "GET 'show'" do

    subject { get :show, :id => src_set.name }

    context 'when the name is found' do

      let(:src_set) { FactoryGirl.create(:src_set) }

      it 'assigns the source set' do
        subject

        expect(assigns(:src_set)).to eq src_set
      end

      it 'assigns the source images' do
        subject

        expect(assigns(:src_images)).to eq src_set.src_images
      end

      it 'returns success' do
        subject

        expect(response).to be_success
      end

    end

    context 'when the name is not found' do

      it 'raises record not found' do
        expect {
          get 'show', :id => 'abc'
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context 'when the set is deleted' do

      let(:src_set) { FactoryGirl.create(:src_set, :is_deleted => true) }

      it 'returns not found' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

  describe "DELETE 'destroy'" do

    let(:src_set) { FactoryGirl.create(:src_set, :user => user) }
    subject { delete :destroy, :id => src_set.name }

    context 'when the name is found' do

      it 'marks the record as deleted in the database' do
        subject
        expect { SrcSet.find(src_set).is_deleted? }.to be_true
      end

      it 'redirects to the index page' do
        subject
        expect(response).to redirect_to :action => :index
      end

    end

    context 'when the name is not found' do

      it 'raises record not found' do
        expect {
          delete :destroy, :id => 'abc'
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context 'when the image is owned by another user' do

      let(:src_set) { FactoryGirl.create(:src_set, :user => user2) }

      it 'returns not found' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context 'when the user is not logged in' do

      it 'returns not found' do
        controller.stub(:current_user => nil)

        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    context 'when the set is deleted' do

      let(:src_set) { FactoryGirl.create(:src_set, :user => user, :is_deleted => true) }

      it 'returns not found' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

end
