require 'spec_helper'

describe "users/new.html.erb" do

  subject {
    assign(:user, [ stub_model(User) ])

    render
  }

  it { should have_selector('input', :id => 'user_email') }

  it { should have_selector('input', :id => 'user_password') }

  it { should have_selector('input', :id => 'user_password_confirmation') }

end
