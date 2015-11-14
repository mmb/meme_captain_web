require 'rails_helper'

describe DashboardController, type: :controller do
  describe '#show' do
    before(:each) { session[:user_id] = user.try(:id) }

    context 'when the user is not logged in' do
      let(:user) { nil }
      it 'returns forbidden' do
        get(:show)
        expect(response).to be_forbidden
      end
    end

    context 'when the user is not an admin user' do
      let(:user) { FactoryGirl.create(:user) }

      it 'returns forbidden' do
        get(:show)
        expect(response).to be_forbidden
      end
    end

    context 'when the user is an admin user' do
      let(:user) { FactoryGirl.create(:admin_user) }

      it 'counts the gend images created in the last 24 hours' do
        FactoryGirl.create(:gend_image, created_at: Time.now - 25.hours)
        FactoryGirl.create(:gend_image, created_at: Time.now - 23.hours)
        FactoryGirl.create(:gend_image)

        get(:show)

        expect(assigns(:gend_images_last_24h)).to eq(2)
      end

      it 'counts the src images created in the last 24 hours' do
        FactoryGirl.create(:src_image, created_at: Time.now - 25.hours)
        FactoryGirl.create(:src_image, created_at: Time.now - 23.hours)
        FactoryGirl.create(:src_image)

        get(:show)

        expect(assigns(:src_images_last_24h)).to eq(2)
      end
    end
  end
end
