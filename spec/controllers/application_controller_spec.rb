require 'rails_helper'

describe ApplicationController, type: :controller do
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
