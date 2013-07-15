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

      it 'shows public images' do
        3.times { FactoryGirl.create(:gend_image, :user => user, :work_in_progress => false, :private => false) }

        subject

        expect(assigns(:gend_images).size).to eq 3
      end

      it 'does not show private images' do
        FactoryGirl.create(:gend_image, :user => user, :work_in_progress => false, :private => false)
        2.times { FactoryGirl.create(:gend_image, :user => user, :work_in_progress => false, :private => true) }

        subject

        expect(assigns(:gend_images).size).to eq 1
      end

    end

    it "shows src sets sorted by reverse quality and reverse updated time" do
      set1 = FactoryGirl.create(:src_set_with_src_image, user: user, quality: 1, updated_at: 1.second.from_now)
      set2 = FactoryGirl.create(:src_set_with_src_image, user: user, updated_at: 2.seconds.from_now)
      set3 = FactoryGirl.create(:src_set_with_src_image, user: user, updated_at: 3.seconds.from_now)

      subject

      expect(assigns(:src_sets)).to eq [set1, set3, set2]
    end

    it 'does not show empty src sets' do
      set1 = FactoryGirl.create(:src_set_with_src_image)
      FactoryGirl.create(:src_set)

      subject

      expect(assigns(:src_sets)).to eq [set1]
    end

    it 'does not show private source images' do
      si1 = FactoryGirl.create(:src_image, private: true)
      si2 = FactoryGirl.create(:src_image)

      subject

      expect(assigns(:src_images)).to eq [si2]
    end

    it 'does not show deleted source images' do
      si1 = FactoryGirl.create(:src_image, is_deleted: true)
      si2 = FactoryGirl.create(:src_image)

      subject

      expect(assigns(:src_images)).to eq [si2]
    end

    it 'shows source images sorted by reverse gend_images_count' do
      si1 = FactoryGirl.create(:src_image, gend_images_count: 10)
      si2 = FactoryGirl.create(:src_image, gend_images_count: 30)
      si3 = FactoryGirl.create(:src_image, gend_images_count: 20)

      subject

      expect(assigns(:src_images)).to eq [si2, si3, si1]
    end

  end

end
