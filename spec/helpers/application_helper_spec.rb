require 'spec_helper'

describe ApplicationHelper do

  let(:user) { user = FactoryGirl.create(:user) }

  context 'when the user id is found' do
    it 'sets current user to the correct user' do
      session[:user_id] = user.id
      expect(current_user).to eq user
    end
  end

  context 'when the user id not found' do
    it 'sets current user to nil' do
      session[:user_id] = 'not found'
      expect(current_user).to be_nil
    end
  end
end
