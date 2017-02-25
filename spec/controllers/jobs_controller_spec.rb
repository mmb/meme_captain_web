require 'rails_helper'

describe JobsController, type: :controller do
  let(:job) { FactoryGirl.create(:job) }

  before(:each) { session[:user_id] = user.try(:id) }

  describe "DELETE 'destroy'" do
    context 'when the user is not an admin' do
      let(:user) { FactoryGirl.create(:user) }

      it 'returns forbidden' do
        delete(:destroy, params: { id: job.id })
        expect(response).to be_forbidden
      end
    end

    context 'when the user is an admin' do
      let(:user) { FactoryGirl.create(:admin_user) }

      it 'deletes the job' do
        expect do
          delete(:destroy, params: { id: job.id })
        end.to change {
                 Delayed::Job.exists?(job.id)
               }.from(true).to(false)
        expect(response).to be_success
      end
    end
  end
end
