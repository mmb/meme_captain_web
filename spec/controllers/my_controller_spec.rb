# encoding: UTF-8

require 'rails_helper'

require 'digest/md5'

describe MyController, type: :controller do
  let(:user) { FactoryGirl.create(:user, api_token: 'secret') }
  let(:user2) { FactoryGirl.create(:user) }

  describe '#show' do
    before(:each) do
      session[:user_id] = user.try(:id)
    end

    context 'when the user is logged in' do
      it "loads the user's source sets" do
        FactoryGirl.create(:src_set,
                           user: user2,
                           updated_at: 1.second.from_now)
        set2 = FactoryGirl.create(:src_set,
                                  user: user,
                                  updated_at: 2.seconds.from_now)
        set3 = FactoryGirl.create(:src_set,
                                  user: user,
                                  updated_at: 3.seconds.from_now)

        get :show
        expect(assigns(:src_sets)).to eq [set3, set2]
      end

      it "loads the user's source images" do
        si1 = FactoryGirl.create(:src_image,
                                 user: user,
                                 updated_at: 1.second.from_now)
        FactoryGirl.create(:src_image,
                           user: user2,
                           updated_at: 2.seconds.from_now)
        si3 = FactoryGirl.create(:src_image,
                                 user: user,
                                 updated_at: 3.seconds.from_now)

        get :show
        expect(assigns(:src_images)).to eq [si3, si1]
      end

      it "loads the user's gend images" do
        gi1 = FactoryGirl.create(:gend_image,
                                 user: user,
                                 updated_at: 1.second.from_now)
        gi2 = FactoryGirl.create(:gend_image,
                                 user: user,
                                 updated_at: 2.seconds.from_now)
        FactoryGirl.create(:gend_image,
                           user: user2,
                           updated_at: 3.seconds.from_now)

        get :show
        expect(assigns(:gend_images)).to eq [gi2, gi1]
      end

      it "sets the API token to the user's API token" do
        get(:show)
        expect(assigns(:api_token)).to eq('secret')
      end
    end

    context 'when the user it not logged in' do
      let(:user) { nil }

      it 'redirects to the login form' do
        get :show
        expect(response).to redirect_to new_session_path
      end

      it 'sets the API token to nil' do
        get(:show)
        expect(assigns(:api_token)).to be_nil
      end
    end
  end
end
