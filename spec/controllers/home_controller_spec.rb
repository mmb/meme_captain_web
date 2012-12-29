require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    it "returns http success" do
      controller.stub_chain(:current_user, :src_images) { [] }
      controller.stub_chain(:current_user, :gend_images) { [] }

      get 'index'
      expect(response).to be_success
    end
  end

end
