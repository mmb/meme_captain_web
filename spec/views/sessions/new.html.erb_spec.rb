require 'spec_helper'

describe "sessions/new.html.erb" do

  subject { render }

  it { should have_selector('input', :id => 'email') }

  it { should have_selector('input', :id => 'password') }
end
