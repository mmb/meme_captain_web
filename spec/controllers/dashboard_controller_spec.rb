require 'rails_helper'

describe DashboardController, type: :controller do
  describe '#show' do
    before(:each) { session[:user_id] = user.try(:id) }

    context 'when the user is not logged in' do
      let(:user) { nil }
      it 'returns forbidden' do
        get(:show)
        expect(response).to be_forbidden
      end
    end

    context 'when the user is not an admin user' do
      let(:user) { FactoryGirl.create(:user) }

      it 'returns forbidden' do
        get(:show)
        expect(response).to be_forbidden
      end
    end

    context 'when the user is an admin user' do
      let(:user) { FactoryGirl.create(:admin_user) }

      it 'counts the gend image creation successes in the last 24 hours' do
        FactoryGirl.create(:gend_image, created_at: Time.now - 25.hours)
        FactoryGirl.create(:gend_image, created_at: Time.now - 23.hours)
        FactoryGirl.create(:gend_image)
        FactoryGirl.create(:gend_image, error: 'failed')

        get(:show)

        expect(assigns(:gend_image_successes_last_24h)).to eq(2)
      end

      it 'counts the gend image creation errors in the last 24 hours' do
        FactoryGirl.create(
          :gend_image, created_at: Time.now - 25.hours, error: 'failed'
        )
        FactoryGirl.create(
          :gend_image, created_at: Time.now - 23.hours, error: 'failed'
        )
        FactoryGirl.create(:gend_image, error: 'failed')
        FactoryGirl.create(:gend_image)

        get(:show)

        expect(assigns(:gend_image_errors_last_24h)).to eq(2)
      end

      it 'calculates the gend image creation success rate in the last 24 ' \
        'hours' do
        FactoryGirl.create(:gend_image, created_at: Time.now - 25.hours)
        FactoryGirl.create(:gend_image, created_at: Time.now - 23.hours)
        FactoryGirl.create(:gend_image)
        FactoryGirl.create(:gend_image, error: 'failed')

        get(:show)

        expect(assigns(:gend_image_success_rate_last_24h)).to eq(66.67)
      end

      context 'when there have been no gend images in the last 24 hours' do
        it 'reports 100.00% success rate' do
          get(:show)

          expect(assigns(:gend_image_success_rate_last_24h)).to eq(100.00)
        end
      end

      it 'counts the src images created in the last 24 hours' do
        FactoryGirl.create(:src_image, created_at: Time.now - 25.hours)
        FactoryGirl.create(:src_image, created_at: Time.now - 23.hours)
        FactoryGirl.create(:src_image)

        get(:show)

        expect(assigns(:src_images_last_24h)).to eq(2)
      end

      it 'counts the users created in the last 24 hours' do
        FactoryGirl.create(:user, created_at: Time.now - 25.hours)
        FactoryGirl.create(:user, created_at: Time.now - 23.hours)
        # another user is created in let

        get(:show)

        expect(assigns(:new_users_last_24h)).to eq(2)
      end

      it 'sets the last 20 searches with no results' do
        searches = []
        21.times do |i|
          searches << NoResultSearch.create(query: "q#{i + 1}")
        end

        get(:show)

        expect(assigns(:no_result_searches)).to eq(
          searches.slice(1, 20).reverse
        )
      end

      it 'sets jobs that have not been attempted yet oldest first' do
        job1 = FactoryGirl.create(:job, created_at: Time.at(0))
        job2 = FactoryGirl.create(:job, created_at: Time.at(60))

        get(:show)

        expect(assigns(:jobs)).to eq([job1, job2])
      end
    end
  end
end
