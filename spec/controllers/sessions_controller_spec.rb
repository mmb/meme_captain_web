# encoding: UTF-8

require 'rails_helper'

describe SessionsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }

  describe "POST 'create'" do

    context 'when login succeeds' do

      it 'creates a session' do
        post :create, email: user.email, password: user.password

        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to the my url' do
        post :create, email: user.email, password: user.password

        expect(response).to redirect_to my_url
      end

      it 'informs the user of login success with flash' do
        post :create, email: user.email, password: user.password

        expect(flash[:notice]).to eq('Logged in.')
      end

      context 'when the session has a return to url' do
        let(:return_to) { 'foo' }

        before(:each) do
          session[:return_to] = return_to
        end

        it 'redirects to the return to url' do
          post :create, email: user.email, password: user.password
          expect(response).to redirect_to return_to
        end

        it 'removes the return to url from the session' do
          post :create, email: user.email, password: user.password
          expect(session[:return_to]).to be_nil
        end
      end

    end

    context 'when login fails' do

      it 'does not create a session' do
        post :create, email: user.email, password: 'wrongpass'
        expect(session[:user_id]).to be_nil
      end

      it 'renders the new template' do
        post :create, email: user.email, password: 'wrongpass'
        expect(response).to render_template('new')
      end

      it 'informs the user of login failure with flash' do
        post :create, email: user.email, password: 'wrongpass'
        expect(flash[:error]).to eq('Login failed.')
      end

    end

    context 'when the email case does not match' do

      it 'allows the user to login' do
        post :create, email: user.email.upcase, password: user.password

        expect(session[:user_id]).to eq(user.id)
      end

    end

  end

  describe "DELETE 'destroy'" do

    context 'when the user is logged in ' do

      before do
        post :create, email: user.email, password: user.password
      end

      it 'clears the session' do
        delete :destroy
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to the root url' do
        delete :destroy
        expect(response).to redirect_to root_url
      end

      it 'informs the user of login failure with flash' do
        delete :destroy
        expect(flash[:notice]).to eq('Logged out.')
      end

    end

    context 'when the user is logged out' do

      it 'clears the session' do
        delete :destroy
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to the root url' do
        delete :destroy
        expect(response).to redirect_to root_url
      end

    end

  end

end
