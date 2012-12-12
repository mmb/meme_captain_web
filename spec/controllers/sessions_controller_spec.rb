require 'spec_helper'

describe SessionsController do

  let(:mock_user) { mock_model(User) }
  let(:user) { User.create!(FactoryGirl.attributes_for(:user)) }

  describe "POST 'create'" do

    context 'when login succeeds' do

      it 'authenticates the user' do
        User.should_receive(:find_by_email).with(user.email).
          and_return(mock_user)

        mock_user.should_receive(:authenticate).with(user.password).
          and_return(true)

        post :create, :email => user.email, :password => user.password
      end

      it 'creates a session' do
        post :create, :email => user.email, :password => user.password

        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to the root url' do
        post :create, :email => user.email, :password => user.password

        expect(response).to redirect_to root_url
      end

      it 'informs the user of login success with flash' do
        post :create, :email => user.email, :password => user.password

        expect(flash[:notice]).to eq('Logged in.')
      end
    end

    context 'when login fails' do

      before(:each) do
        post :create, :email => user.email, :password => 'wrongpass'
      end

      it 'does not create a session' do
        expect(session[:user_id]).to be_nil
      end

      it 'renders the new template' do
        expect(response).to render_template('new')
      end

      it 'informs the user of login failure with flash' do
        expect(flash[:error]).to eq('Login failed.')
      end

    end

  end

  describe "DELETE 'destroy'" do

    context 'when the user is logged in ' do

      before do
        post :create, :email => user.email, :password => user.password
      end

      before(:each) do
        delete :destroy
      end

      it 'clears the session' do
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to the root url' do
        expect(response).to redirect_to root_url
      end

      it 'informs the user of login failure with flash' do
        expect(flash[:notice]).to eq('Logged out.')
      end

    end

    context 'when the user is logged out' do

      before(:each) do
        delete :destroy
      end

      it 'clears the session' do
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to the root url' do
        expect(response).to redirect_to root_url
      end

    end

  end

end
