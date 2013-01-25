require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do

    let(:user) { FactoryGirl.create(:user) }

    let(:src_set) { FactoryGirl.create(:src_set) }
    let(:src_image) { FactoryGirl.create(:src_image, :user => user) }
    let(:gend_image) { FactoryGirl.create(:gend_image, :src_image => src_image) }

    before(:each) do
      controller.stub(:current_user => user)
    end

    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

end
