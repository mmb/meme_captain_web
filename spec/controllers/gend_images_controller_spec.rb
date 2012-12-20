require 'spec_helper'

describe GendImagesController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      expect(response).to be_success
    end
  end

  it 'should have more specs'

end
