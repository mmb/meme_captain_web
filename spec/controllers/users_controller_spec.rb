require 'rails_helper'

describe UsersController, type: :controller do
  describe "GET 'new'" do
    it 'returns http success' do
      get(:new)
      expect(response).to be_success
    end
  end

  describe "POST 'create'" do
    context 'with valid attributes' do
      it 'saves the new user to the database' do
        expect do
          post(:create, params: { user: FactoryGirl.attributes_for(:user) })
        end.to change { User.count }.by(1)
      end

      it 'redirects to the my page' do
        post(:create, params: { user: FactoryGirl.attributes_for(:user) })

        expect(response).to redirect_to my_url
      end

      it 'logs the user in' do
        post(:create, params: { user: FactoryGirl.attributes_for(:user) })

        expect(session[:user_id]).to eq(User.last.id)
      end

      context 'when ActiveModel::SecurePassword.min_cost is false' do
        before do
          @prev = ActiveModel::SecurePassword.min_cost
          ActiveModel::SecurePassword.min_cost = false
        end

        after do
          ActiveModel::SecurePassword.min_cost = @prev
        end

        it 'saves the new user to the database' do
          expect do
            post(:create, params: { user: FactoryGirl.attributes_for(:user) })
          end.to(change { User.count }.by(1))
        end
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new user in the database' do
        expect do
          post(:create, params: {
                 user: FactoryGirl.attributes_for(:invalid_user)
               })
        end.to_not(change { User.count })
      end

      it 're-renders the new template' do
        post(:create, params: {
               user: FactoryGirl.attributes_for(:invalid_user)
             })

        expect(response).to render_template('new')
      end
    end
  end
end
