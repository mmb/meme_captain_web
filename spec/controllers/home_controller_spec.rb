require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do

    let(:user) { FactoryGirl.create(:user) }

    let(:src_image) { FactoryGirl.create(:src_image, :user => user) }

    subject { get :index }

    before(:each) do
      controller.stub(:current_user => user)
    end

    it "returns http success" do
      subject
      expect(response).to be_success
    end

    context 'when not logged in' do
      let(:user) { nil }

      context 'under construction images' do

        it 'does not show generated images that are under construction' do
          FactoryGirl.create(:gend_image, :src_image => src_image, :user => user)
          subject
          expect(assigns(:gend_images)).to be_empty
        end

      end

    end

    it "shows src sets sorted by reverse quality and reverse updated time" do
      set1 = FactoryGirl.create(:src_set, :user => user, :quality => 1)
      set2 = FactoryGirl.create(:src_set, :user => user)
      set3 = FactoryGirl.create(:src_set, :user => user)

      subject

      expect(assigns(:src_sets)).to eq [set1, set3, set2]
    end

  end

end
