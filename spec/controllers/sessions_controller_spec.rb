require 'spec_helper'

describe SessionsController do

  let(:mock_user) { mock_model(User) }
  let(:user) { FactoryGirl.create(:user) }

  describe "POST 'create'" do

    subject { post :create, :email => user.email, :password => user.password }

    context 'when login succeeds' do

      it 'authenticates the user' do
        User.should_receive(:find_by_email).with(user.email).
            and_return(mock_user)

        mock_user.should_receive(:authenticate).with(user.password).
            and_return(true)

        subject
      end

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
