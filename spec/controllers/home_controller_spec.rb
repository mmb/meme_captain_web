# encoding: UTF-8

require 'rails_helper'

describe HomeController, type: :controller do
  describe "GET 'index'" do
    let(:user) { nil }

    let(:src_image) do
      FactoryGirl.create(:src_image,
                         user: user,
                         work_in_progress: false)
    end

    before(:each) do
      session[:user_id] = user.try(:id)
    end

    it 'returns http success' do
      get :index
      expect(response).to be_success
    end

    context 'when the user is not logged in' do
      let(:user) { nil }

      it 'shows public source images' do
        3.times do
          FactoryGirl.create(:src_image,
                             user: user,
                             work_in_progress: false,
                             private: false)
        end

        get :index

        expect(assigns(:src_images).size).to eq(3)
      end

      it 'does not show private source images' do
        FactoryGirl.create(:src_image,
                           private: true,
                           work_in_progress: false)
        si2 = FactoryGirl.create(:src_image, work_in_progress: false)

        get :index

        expect(assigns(:src_images)).to eq([si2])
      end

      it 'does not show deleted source images' do
        FactoryGirl.create(:src_image,
                           is_deleted: true,
                           work_in_progress: false)
        si2 = FactoryGirl.create(:src_image, work_in_progress: false)

        get :index

        expect(assigns(:src_images)).to eq([si2])
      end

      it 'does not show source images that are under construction' do
        FactoryGirl.create(:src_image)
        si2 = FactoryGirl.create(:src_image, work_in_progress: false)

        get :index

        expect(assigns(:src_images)).to eq([si2])
      end

      it 'shows public gend images' do
        3.times do
          FactoryGirl.create(:gend_image,
                             user: user,
                             work_in_progress: false,
                             private: false)
        end

        get :index

        expect(assigns(:gend_images).size).to eq(3)
      end

      it 'does not show private gend images' do
        FactoryGirl.create(:gend_image,
                           user: user,
                           work_in_progress: false,
                           private: false)
        2.times do
          FactoryGirl.create(:gend_image,
                             user: user,
                             work_in_progress: false,
                             private: true)
        end

        get :index

        expect(assigns(:gend_images).size).to eq(1)
      end

      it 'does not show deleted gend images' do
        FactoryGirl.create(:gend_image,
                           is_deleted: true,
                           work_in_progress: false)
        gi2 = FactoryGirl.create(:gend_image, work_in_progress: false)

        get :index

        expect(assigns(:gend_images)).to eq([gi2])
      end

      it 'does not show gend images that are under construction' do
        FactoryGirl.create(:gend_image, src_image: src_image, user: user)
        get :index
        expect(assigns(:gend_images)).to be_empty
      end
    end

    context 'when the user is logged in' do
      let(:user) { FactoryGirl.create(:user) }

      it 'shows public source images' do
        3.times do
          FactoryGirl.create(:src_image,
                             user: user,
                             work_in_progress: false,
                             private: false)
        end

        get :index

        expect(assigns(:src_images).size).to eq(3)
      end

      it 'does not show private source images' do
        FactoryGirl.create(:src_image,
                           private: true,
                           work_in_progress: false)
        si2 = FactoryGirl.create(:src_image, work_in_progress: false)

        get :index

        expect(assigns(:src_images)).to eq([si2])
      end

      it 'does not show deleted source images' do
        FactoryGirl.create(:src_image,
                           is_deleted: true,
                           work_in_progress: false)
        si2 = FactoryGirl.create(:src_image, work_in_progress: false)

        get :index

        expect(assigns(:src_images)).to eq([si2])
      end

      it 'does not show source images that are under construction' do
        FactoryGirl.create(:src_image)
        si2 = FactoryGirl.create(:src_image, work_in_progress: false)

        get :index

        expect(assigns(:src_images)).to eq([si2])
      end

      it 'shows public gend images' do
        3.times do
          FactoryGirl.create(:gend_image,
                             user: user,
                             work_in_progress: false,
                             private: false)
        end

        get :index

        expect(assigns(:gend_images).size).to eq(3)
      end

      it 'does not show private gend images' do
        FactoryGirl.create(:gend_image,
                           user: user,
                           work_in_progress: false,
                           private: false)
        2.times do
          FactoryGirl.create(:gend_image,
                             user: user,
                             work_in_progress: false,
                             private: true)
        end

        get :index

        expect(assigns(:gend_images).size).to eq(1)
      end

      it 'does not show deleted gend images' do
        FactoryGirl.create(:gend_image,
                           is_deleted: true,
                           work_in_progress: false)
        gi2 = FactoryGirl.create(:gend_image, work_in_progress: false)

        get :index

        expect(assigns(:gend_images)).to eq([gi2])
      end

      it 'does not show gend images that are under construction' do
        FactoryGirl.create(:gend_image, src_image: src_image, user: user)
        get :index
        expect(assigns(:gend_images)).to be_empty
      end
    end

    context 'when the user is an admin user' do
      let(:user) { FactoryGirl.create(:admin_user) }

      it 'shows public source images' do
        3.times do
          FactoryGirl.create(:src_image,
                             user: user,
                             work_in_progress: false,
                             private: false)
        end

        get :index

        expect(assigns(:src_images).size).to eq(3)
      end

      it 'shows private source images' do
        si = FactoryGirl.create(
          :src_image,
          private: true,
          work_in_progress: false)
        si2 = FactoryGirl.create(:src_image, work_in_progress: false)

        get :index

        expect(assigns(:src_images)).to eq([si2, si])
      end

      it 'shows deleted source images' do
        si = FactoryGirl.create(
          :src_image,
          is_deleted: true,
          work_in_progress: false)
        si2 = FactoryGirl.create(:src_image, work_in_progress: false)

        get :index

        expect(assigns(:src_images)).to eq([si2, si])
      end

      it 'show source images that are under construction' do
        si = FactoryGirl.create(:src_image)
        si2 = FactoryGirl.create(:src_image, work_in_progress: false)

        get :index

        expect(assigns(:src_images)).to eq([si2, si])
      end

      it 'shows public gend images' do
        3.times do
          FactoryGirl.create(:gend_image,
                             user: user,
                             work_in_progress: false,
                             private: false)
        end

        get :index

        expect(assigns(:gend_images).size).to eq(3)
      end

      it 'shows private gend images' do
        FactoryGirl.create(:gend_image,
                           user: user,
                           work_in_progress: false,
                           private: false)
        2.times do
          FactoryGirl.create(:gend_image,
                             user: user,
                             work_in_progress: false,
                             private: true)
        end

        get :index

        expect(assigns(:gend_images).size).to eq(3)
      end

      it 'shows deleted gend images' do
        gi = FactoryGirl.create(
          :gend_image,
          is_deleted: true,
          work_in_progress: false)
        gi2 = FactoryGirl.create(:gend_image, work_in_progress: false)

        get :index

        expect(assigns(:gend_images)).to eq([gi2, gi])
      end

      it 'show gend images that are under construction' do
        gi = FactoryGirl.create(:gend_image, src_image: src_image, user: user)
        get :index
        expect(assigns(:gend_images)).to eq([gi])
      end
    end

    it 'shows src sets sorted by reverse quality and reverse updated time' do
      set1 = FactoryGirl.create(:src_set_with_src_image,
                                user: user,
                                quality: 1,
                                updated_at: 1.second.from_now)
      set2 = FactoryGirl.create(:src_set_with_src_image,
                                user: user,
                                updated_at: 2.seconds.from_now)
      set3 = FactoryGirl.create(:src_set_with_src_image,
                                user: user,
                                updated_at: 3.seconds.from_now)

      get :index

      expect(assigns(:src_sets)).to eq([set1, set3, set2])
    end

    it 'does not show empty src sets' do
      set1 = FactoryGirl.create(:src_set_with_src_image)
      FactoryGirl.create(:src_set)

      get :index

      expect(assigns(:src_sets)).to eq([set1])
    end

    it 'shows source images sorted by reverse gend_images_count' do
      si1 = FactoryGirl.create(:src_image,
                               gend_images_count: 10,
                               work_in_progress: false)
      si2 = FactoryGirl.create(:src_image,
                               gend_images_count: 30,
                               work_in_progress: false)
      si3 = FactoryGirl.create(:src_image,
                               gend_images_count: 20,
                               work_in_progress: false)

      get :index

      expect(assigns(:src_images)).to eq([si2, si3, si1])
    end
  end
end
