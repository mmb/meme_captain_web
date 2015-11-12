# encoding: UTF-8

require 'rails_helper'

describe ApiTokensController, type: :controller do
  describe "POST 'create'" do
    before do
      session[:user_id] = user.try(:id)
      request.accept = 'application/json'
    end

    context 'when the user is logged in' do
      let(:user) { FactoryGirl.create(:user) }

      it 'generates a new API token for the user' do
        expect do
          post(:create)
          user.reload
        end.to change { user.api_token }
      end

      it 'returns success' do
        post(:create)
        expect(response).to be_success
      end

      it 'returns the new API token' do
        post(:create)
        user.reload
        expect(JSON.parse(response.body)).to eq('token' => user.api_token)
      end
    end

    context 'when the user is not logged in' do
      let(:user) { nil }

      it 'returns unauthorized' do
        post(:create)
        expect(response).to be_forbidden
      end
    end
  end
end
