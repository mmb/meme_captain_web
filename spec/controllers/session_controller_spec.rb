require 'spec_helper'

describe SessionController do

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

        session[:user_id].should == user.id
      end

      it 'redirects to the root url' do
        post :create, :email => user.email, :password => user.password

        response.should redirect_to root_url
      end

      it 'informs the user of login success with flash' do
        post :create, :email => user.email, :password => user.password

        flash[:notice].should == 'Signed in.'
      end
    end

    context 'when login fails' do

      before(:each) do
        post :create, :email => user.email, :password => 'wrongpass'
      end

      it 'does not create a session' do
        session[:user_id].should be_nil
      end

      it 'renders the new template' do
        response.should render_template('new')
      end

      it 'informs the user of login failure with flash' do
        flash[:error].should == 'Login failed.'
      end

    end

  end

end
