require 'rails_helper'

describe ApplicationController, type: :controller do
  describe '#current_user' do
    context 'when the user id is found' do
      let(:user) { FactoryGirl.create(:user) }

      it 'sets current user to the correct user' do
        session[:user_id] = user.id
        expect(controller.current_user).to eq user
      end
    end

    context 'when the user id not found' do
      it 'sets current user to nil' do
        session[:user_id] = 'not found'
        expect(controller.current_user).to be_nil
      end
    end

    context 'when the user sends an API token' do
      let!(:user) { FactoryGirl.create(:user, api_token: 'abc123') }
      before do
        request.headers['Authorization'] = "Token token=\"#{request_token}\""
      end

      context 'when the API token is valid' do
        let(:request_token) { 'abc123' }
        it 'sets the current user to the user that owns the token' do
          expect(controller.current_user).to eq(user)
        end
      end

      context 'when the API token is invalid' do
        let(:request_token) { 'invalid' }
        it 'set the current user to bil' do
          expect(controller.current_user).to be_nil
        end
      end

      context 'when the API token is empty' do
        let(:request_token) { '' }
        it 'does not authenicate a user with an empty API token' do
          FactoryGirl.create(:user)
          expect(controller.current_user).to be_nil
        end
      end

      context 'when both an API token and a session user are present' do
        let(:request_token) { 'abc123' }
        it 'returns the token user' do
          session_user = FactoryGirl.create(:user)
          session[:user_id] = session_user.id
          expect(controller.current_user).to eq(user)
        end
      end
    end
  end

  describe '#admin?' do
    before(:each) { session[:user_id] = user.try(:id) }

    context 'when the user is not logged in' do
      let(:user) { nil }
      it 'is false' do
        expect(controller.admin?).to be_falsey
      end
    end

    context 'when the user is not an admin' do
      let(:user) { FactoryGirl.create(:user) }
      it 'is false' do
        expect(controller.admin?).to be_falsey
      end
    end

    context 'when the user is an admin' do
      let(:user) { FactoryGirl.create(:admin_user) }
      it 'is true' do
        expect(controller.admin?).to eq(true)
      end
    end
  end
end
