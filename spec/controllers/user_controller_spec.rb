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

      it 'saves the new user to the database' do
        expect {
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to change{User.count}.by(1)
      end

      it 'redirects to the home page' do
        post :create, user: FactoryGirl.attributes_for(:user)

        response.should redirect_to root_url
      end

    end

    context 'with invalid attributes' do

      it 'does not save the new user in the database' do
        expect {
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
        }.to_not change{User.count}
      end

      it 're-renders the new template' do
        post :create, user: FactoryGirl.attributes_for(:invalid_user)

        response.should render_template('new')
      end

    end

  end

end
