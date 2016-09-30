# encoding: UTF-8

require 'rails_helper'

describe SrcSetsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

  before(:each) do
    session[:user_id] = user.try(:id)
  end

  describe "GET 'new'" do
    it 'does not match a route' do
      expect { get :new }.to raise_error ActionController::UrlGenerationError
    end
  end

  describe "POST 'create'" do
    context 'with valid attributes' do
      it 'saves the new src set to the database' do
        expect do
          post :create, src_set: { name: 'test' }
        end.to change { SrcSet.count }.by(1)
      end

      it 'redirects to the index' do
        post :create, src_set: { name: 'test' }

        expect(response).to redirect_to action: :index
      end

      it 'informs the user of success with flash' do
        post :create, src_set: { name: 'test' }

        expect(flash[:notice]).to eq('Source set created.')
      end
    end

    context 'with invalid attributes' do
      it 'renders the form again' do
        post :create, src_set: {}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET 'index'" do
    it 'returns http success' do
      get :index
      expect(response).to be_success
    end

    it 'shows all source sets sorted by reverse updated time' do
      3.times { FactoryGirl.create(:src_set_with_src_image, user: user) }

      get :index

      src_sets = assigns(:src_sets)

      expect(
        src_sets[0].updated_at >= src_sets[1].updated_at &&
        src_sets[1].updated_at >= src_sets[2].updated_at
      ).to eq(true)
    end

    it 'does not show deleted src sets' do
      set1 = FactoryGirl.create(:src_set_with_src_image, user: user)
      FactoryGirl.create(:src_set_with_src_image, user: user, is_deleted: true)

      get :index

      expect(assigns(:src_sets)).to eq [set1]
    end

    it 'does not show empty source sets' do
      set1 = FactoryGirl.create(:src_set_with_src_image, user: user)
      FactoryGirl.create(:src_set, user: user)

      get :index

      expect(assigns(:src_sets)).to eq [set1]
    end

    context 'when the user is not logged in' do
      let(:user) { nil }

      it 'shows all source sets sorted by reverse updated time' do
        3.times { FactoryGirl.create(:src_set_with_src_image, user: user) }

        get :index

        src_sets = assigns(:src_sets)

        expect(
          src_sets[0].updated_at >= src_sets[1].updated_at &&
          src_sets[1].updated_at >= src_sets[2].updated_at
        ).to eq(true)
      end
    end
  end

  describe "PUT 'update'" do
    let(:src_image) { FactoryGirl.create(:src_image) }
    let(:src_image2) { FactoryGirl.create(:src_image) }
    let(:src_set) { FactoryGirl.create(:src_set, user: user) }

    context 'adding source images' do
      it 'adds source images to the set' do
        expect do
          put :update,
              id: src_set.name,
              add_src_images: [src_image.id_hash, src_image2.id_hash]
          src_set.reload
        end.to change { src_set.src_images.size }.by(2)
      end

      it "changes the set's updated time" do
        src_set.update_column(:updated_at, Time.now - 1)
        expect do
          put :update,
              id: src_set.name,
              add_src_images: [src_image.id_hash, src_image2.id_hash]
          src_set.reload
        end.to change { src_set.updated_at }
      end

      it 'redirects to the source set' do
        put :update,
            id: src_set.name,
            add_src_images: [src_image.id_hash, src_image2.id_hash]
        src_set.reload

        expect(response).to redirect_to action: :show
      end

      it 'informs the user of success with a notice' do
        put :update,
            id: src_set.name,
            add_src_images: [src_image.id_hash, src_image2.id_hash]
        src_set.reload

        expect(flash[:notice]).to eq 'The set was successfully updated.'
      end
    end

    context 'deleting source images' do
      before(:each) do
        put :update,
            id: src_set.name,
            add_src_images: [src_image.id_hash, src_image2.id_hash]
      end

      it 'deletes source images from the set' do
        expect do
          put :update,
              id: src_set.name,
              delete_src_images: [src_image.id_hash, src_image2.id_hash]
          src_set.reload
        end.to change { src_set.src_images.size }.by(-2)
      end

      it "changes the set's updated time" do
        src_set.update_column(:updated_at, Time.now - 1)
        expect do
          put :update,
              id: src_set.name,
              delete_src_images: [src_image.id_hash, src_image2.id_hash]
          src_set.reload
        end.to change { src_set.updated_at }
      end

      it 'redirects to the source set' do
        put :update,
            id: src_set.name,
            delete_src_images: [src_image.id_hash, src_image2.id_hash]
        src_set.reload

        expect(response).to redirect_to action: :show
      end

      it 'informs the user of success with a notice' do
        put :update,
            id: src_set.name,
            delete_src_images: [src_image.id_hash, src_image2.id_hash]
        src_set.reload

        expect(flash[:notice]).to eq 'The set was successfully updated.'
      end
    end

    context 'changing the name' do
      it 'has the new name' do
        put :update, id: src_set.name, src_set: { name: 'newname' }
        src_set.reload

        expect(src_set.name).to eq 'newname'
      end

      it 'redirects to the source set' do
        put :update, id: src_set.name, src_set: { name: 'newname' }
        src_set.reload

        expect(response).to redirect_to action: :show, id: 'newname'
      end

      it 'informs the user of success with a notice' do
        put :update, id: src_set.name, src_set: { name: 'newname' }
        src_set.reload

        expect(flash[:notice]).to eq 'The set was successfully updated.'
      end
    end

    context 'when the source set is owned by another user' do
      it "doesn't allow it to be updated" do
        src_set = FactoryGirl.create(:src_set, user: user2)

        put :update, id: src_set.name, src_set: { name: 'newname' }

        expect(response).to be_forbidden
      end
    end

    context "when the set doesn't exist" do
      it 'creates the set' do
        expect do
          put :update, id: 'a new set', add_src_images: [src_image.id_hash]
        end.to change { SrcSet.count }.by(1)
      end
    end

    context 'when the set is deleted' do
      let(:src_set) { FactoryGirl.create(:src_set, is_deleted: true) }

      it 'creates the set' do
        put :update, id: src_set.name, src_set: { name: 'newname' }
        expect(SrcSet.last.name).to eq('newname')
      end
    end
  end

  describe "GET 'show'" do
    context 'when the name is found' do
      let(:src_set) { FactoryGirl.create(:src_set) }

      it 'assigns the source set' do
        get :show, id: src_set.name

        expect(assigns(:src_set)).to eq src_set
      end

      it 'sorts the source images by reverse gend images count' do
        si1 = FactoryGirl.create(:src_image, gend_images_count: 30)
        si2 = FactoryGirl.create(:src_image, gend_images_count: 10)
        si3 = FactoryGirl.create(:src_image, gend_images_count: 20)

        src_set.src_images << si1
        src_set.src_images << si2
        src_set.src_images << si3

        get :show, id: src_set.name

        expect(assigns(:src_images)).to eq [si1, si3, si2]
      end

      it 'does not show deleted source images' do
        si1 = FactoryGirl.create(:src_image, is_deleted: true)
        si2 = FactoryGirl.create(:src_image)

        src_set.src_images << si1
        src_set.src_images << si2

        get :show, id: src_set.name

        expect(assigns(:src_images)).to eq [si2]
      end

      it 'returns success' do
        get :show, id: src_set.name

        expect(response).to be_success
      end
    end

    context 'when the name is not found' do
      it 'raises record not found' do
        expect do
          get 'show', id: 'abc'
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the set is deleted' do
      let(:src_set) { FactoryGirl.create(:src_set, is_deleted: true) }

      it 'returns not found' do
        expect do
          get :show, id: src_set.name
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE 'destroy'" do
    let(:src_set) { FactoryGirl.create(:src_set, user: user) }

    context 'when the name is found' do
      it 'marks the record as deleted in the database' do
        delete :destroy, id: src_set.name
        expect(SrcSet.find(src_set.id).is_deleted?).to eq(true)
      end

      it 'redirects to the index page' do
        delete :destroy, id: src_set.name
        expect(response).to redirect_to action: :index
      end
    end

    context 'when the name is not found' do
      it 'raises record not found' do
        expect do
          delete :destroy, id: 'abc'
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the image is owned by another user' do
      let(:src_set) { FactoryGirl.create(:src_set, user: user2) }

      it 'returns not found' do
        expect do
          delete :destroy, id: src_set.name
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the user is not logged in' do
      it 'returns not found' do
        session[:user_id] = nil

        expect do
          delete :destroy, id: src_set.name
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the set is deleted' do
      let(:src_set) do
        FactoryGirl.create(:src_set, user: user, is_deleted: true)
      end

      it 'returns not found' do
        expect do
          delete :destroy, id: src_set.name
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
