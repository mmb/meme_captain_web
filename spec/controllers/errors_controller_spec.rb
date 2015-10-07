require 'rails_helper'

describe ErrorsController, type: :controller do
  describe '#index' do
    before(:each) { session[:user_id] = user.try(:id) }

    context 'when the user is not logged in' do
      let(:user) { nil }
      it 'returns forbidden' do
        get(:index)
        expect(response).to be_forbidden
      end
    end

    context 'when the user is not an admin user' do
      let(:user) { FactoryGirl.create(:user) }

      it 'returns forbidden' do
        get(:index)
        expect(response).to be_forbidden
      end
    end

    context 'when the user is an admin user' do
      let(:user) { FactoryGirl.create(:admin_user) }
      let(:relation) { double(ActiveRecord::Relation) }
      let(:result) { double(ActiveRecord::Relation) }

      it 'loads the errored src images' do
        expect(SrcImage).to receive(:without_image).and_return(relation)
        expect(relation).to receive(:where).and_return(relation)
        expect(relation).to receive(:not).with(error: nil).and_return(relation)
        expect(relation).to receive(:order).with(:updated_at).and_return(
          relation)
        expect(relation).to receive(:reverse_order).and_return(result)

        get(:index)

        expect(assigns(:errored_src_images)).to eq(result)
      end

      it 'loads the errored gend images' do
        expect(GendImage).to receive(:without_image).and_return(relation)
        expect(relation).to receive(:where).and_return(relation)
        expect(relation).to receive(:not).with(error: nil).and_return(relation)
        expect(relation).to receive(:order).with(:updated_at).and_return(
          relation)
        expect(relation).to receive(:reverse_order).and_return(result)

        get(:index)

        expect(assigns(:errored_gend_images)).to eq(result)
      end
    end
  end
end
