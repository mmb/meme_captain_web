require 'spec_helper'

describe UserController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do

    context 'with valid attributes' do

      it 'saves the new contact to the database' do
        expect {
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to change{User.count}.by(1)
      end

      it 'redirects to the home page'
    end

    context 'with invalid attributes' do
      it 'does not save the new contact in the database' do
        expect {
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
        }.to_not change{User.count}
      end

      it 're-renders the new template'
    end

  end

end
