require 'spec_helper'

require 'digest/md5'

describe MyController do

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

  describe '#show' do

    subject { get :show }

    before(:each) do
      controller.stub(:current_user => user)
    end

    context 'when the user is logged in' do

      it "loads the user's source sets" do
        set1 = FactoryGirl.create(:src_set, user: user2, updated_at: 1.second.from_now)
        set2 = FactoryGirl.create(:src_set, user: user, updated_at: 2.seconds.from_now)
        set3 = FactoryGirl.create(:src_set, user: user, updated_at: 3.seconds.from_now)

        subject
        expect(assigns(:src_sets)).to eq [set3, set2]
      end

      it "loads the user's source images" do
        si1 = FactoryGirl.create(:src_image, user: user, updated_at: 1.second.from_now)
        si2 = FactoryGirl.create(:src_image, user: user2, updated_at: 2.seconds.from_now)
        si3 = FactoryGirl.create(:src_image, user: user, updated_at: 3.seconds.from_now)

        subject
        expect(assigns(:src_images)).to eq [si3, si1]
      end

      it "loads the user's gend images" do
        gi1 = FactoryGirl.create(:gend_image, user: user, updated_at: 1.second.from_now)
        gi2 = FactoryGirl.create(:gend_image, user: user, updated_at: 2.seconds.from_now)
        gi3 = FactoryGirl.create(:gend_image, user: user2, updated_at: 3.seconds.from_now)

        subject
        expect(assigns(:gend_images)).to eq [gi2, gi1]
      end

      it "sets the user's name" do
        subject
        expect(assigns(:name)).to eq user.email
      end

      it "sets the user's avatar url" do
        subject

        expect(assigns(:avatar_url)).to eq "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}"
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

end
