require 'spec_helper'

describe SessionsController do

  let(:user) { FactoryGirl.create(:user) }

  describe "POST 'create'" do

    subject { post :create, :email => user.email, :password => user.password }

    context 'when login succeeds' do

      it 'creates a session' do
        subject

        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to the root url' do
        subject

        expect(response).to redirect_to root_url
      end

      it 'informs the user of login success with flash' do
        subject

        expect(flash[:notice]).to eq('Logged in.')
      end
    end

    context 'when login fails' do

      subject { post :create, :email => user.email, :password => 'wrongpass' }

      it 'does not create a session' do
        subject
        expect(session[:user_id]).to be_nil
      end

      it 'renders the new template' do
        subject
        expect(response).to render_template('new')
      end

      it 'informs the user of login failure with flash' do
        subject
        expect(flash[:error]).to eq('Login failed.')
      end

    end

    context 'when the email case does not match' do

      it 'allows the user to login' do
        post :create, :email => user.email.upcase, :password => user.password

        expect(session[:user_id]).to eq(user.id)
      end

    end

  end

  describe "DELETE 'destroy'" do

    subject { delete :destroy }

    context 'when the user is logged in ' do

      before do
        post :create, :email => user.email, :password => user.password
      end

      it 'clears the session' do
        subject
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to the root url' do
        subject
        expect(response).to redirect_to root_url
      end

      it 'informs the user of login failure with flash' do
        subject
        expect(flash[:notice]).to eq('Logged out.')
      end

    end

    context 'when the user is logged out' do

      it 'clears the session' do
        subject
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to the root url' do
        subject
        expect(response).to redirect_to root_url
      end

    end

  end

end
