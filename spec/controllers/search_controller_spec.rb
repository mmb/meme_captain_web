# encoding: UTF-8

require 'rails_helper'

describe SearchController, type: :controller do
  describe "GET 'show'" do
    let(:user) { nil }

    before { session[:user_id] = user.try(:id) }

    context 'when no results are found' do
      before { get :show, q: 'test' }

      it 'sets no_results' do
        expect(assigns(:no_results)).to be(true)
      end

      it 'sets template_search' do
        expect(assigns(:template_search)).to eq('test meme template')
      end

      it 'sets google_search_url' do
        expect(assigns(:google_search_url)).to eq(
          'https://www.google.com/search?q=test+meme+template&tbm=isch'
        )
      end

      it 'correctly encodes google_search_url' do
        get :show, q: '<hi&>'
        expect(assigns(:google_search_url)).to eq(
          'https://www.google.com/search?q=%3Chi%26%3E+meme+template&tbm=isch'
        )
      end

      it 'creates a no result search record' do
        expect do
          get(:show, q: 'test')
        end.to change { NoResultSearch.count }.by(1)
        expect(NoResultSearch.last.query).to eq('test')
      end
    end

    context 'when some results are found' do
      before do
        @src_image_1 = FactoryGirl.create(
          :src_image, name: 'foo', work_in_progress: false
        )
        @src_image_2 = FactoryGirl.create(
          :src_image, name: 'not a match', work_in_progress: false
        )
        @src_image_3 = FactoryGirl.create(
          :src_image, name: 'another foo', work_in_progress: false
        )

        caption1 = FactoryGirl.create(:caption, text: 'foo')
        caption2 = FactoryGirl.create(:caption, text: 'bar')
        caption3 = FactoryGirl.create(:caption, text: 'abc')
        caption4 = FactoryGirl.create(:caption, text: 'def')
        caption5 = FactoryGirl.create(:caption, text: 'bar')
        caption6 = FactoryGirl.create(:caption, text: 'foo')
        @gend_image_1 = FactoryGirl.create(:gend_image,
                                           captions: [caption1, caption2],
                                           work_in_progress: false,
                                           src_image: @src_image_1)
        @gend_image_2 = FactoryGirl.create(:gend_image,
                                           captions: [caption3, caption4],
                                           work_in_progress: false,
                                           src_image: @src_image_3)
        @gend_image_2.update!(updated_at: Time.now + 1)
        @gend_image_3 = FactoryGirl.create(:gend_image,
                                           captions: [caption5, caption6],
                                           work_in_progress: false,
                                           src_image: @src_image_3)
        @gend_image_3.update!(updated_at: Time.now + 2)
      end

      context 'when the user is not an admin user' do
        let(:user) { FactoryGirl.create(:user) }

        it 'does not find private source images' do
          FactoryGirl.create(
            :src_image, name: 'foo', work_in_progress: false, private: true
          )
          get :show, q: 'foo'

          expect(assigns(:src_images)).to eq([@src_image_3, @src_image_1])
        end

        it 'does not find deleted source images' do
          FactoryGirl.create(
            :src_image, name: 'foo', work_in_progress: false, is_deleted: true
          )
          get :show, q: 'foo'

          expect(assigns(:src_images)).to eq([@src_image_3, @src_image_1])
        end

        it 'does not find in progress source images' do
          FactoryGirl.create(:src_image, name: 'foo')
          get :show, q: 'foo'

          expect(assigns(:src_images)).to eq([@src_image_3, @src_image_1])
        end

        it 'does not find private gend images' do
          caption1 = FactoryGirl.create(:caption, text: 'foo')
          caption2 = FactoryGirl.create(:caption, text: 'bar')

          FactoryGirl.create(:gend_image,
                             captions: [caption1, caption2],
                             work_in_progress: false,
                             private: true)
          get :show, q: 'foo'

          expect(assigns(:gend_images)).to eq([@gend_image_3, @gend_image_1])
        end

        it 'does not find deleted gend images' do
          caption1 = FactoryGirl.create(:caption, text: 'foo')
          caption2 = FactoryGirl.create(:caption, text: 'bar')
          FactoryGirl.create(:gend_image,
                             captions: [caption1, caption2],
                             work_in_progress: false, is_deleted: true)
          get :show, q: 'foo'

          expect(assigns(:gend_images)).to eq([@gend_image_3, @gend_image_1])
        end

        it 'does not find in progress gend images' do
          caption1 = FactoryGirl.create(:caption, text: 'foo')
          caption2 = FactoryGirl.create(:caption, text: 'bar')
          FactoryGirl.create(:gend_image,
                             captions: [caption1, caption2],
                             work_in_progress: true)
          get :show, q: 'foo'

          expect(assigns(:gend_images)).to eq([@gend_image_3, @gend_image_1])
        end

        it 'does not show the gend image toolbar' do
          get(:show, q: 'foo')

          expect(assigns(:show_toolbar)).to eq(false)
        end
      end

      context 'when the user is an admin user' do
        let(:user) { FactoryGirl.create(:admin_user) }

        it 'finds private source images' do
          src_image_4 = FactoryGirl.create(
            :src_image, name: 'foo', work_in_progress: false, private: true
          )
          src_image_4.update!(updated_at: Time.now + 1)

          get :show, q: 'foo'

          expect(assigns(:src_images)).to eq(
            [@src_image_3, @src_image_1, src_image_4]
          )
        end

        it 'finds deleted source images' do
          src_image_4 = FactoryGirl.create(
            :src_image, name: 'foo', work_in_progress: false, is_deleted: true
          )
          src_image_4.update!(updated_at: Time.now + 1)

          get :show, q: 'foo'

          expect(assigns(:src_images)).to eq(
            [@src_image_3, @src_image_1, src_image_4]
          )
        end

        it 'finds in progress source images' do
          src_image_4 = FactoryGirl.create(:src_image, name: 'foo')
          src_image_4.update!(updated_at: Time.now + 1)

          get :show, q: 'foo'

          expect(assigns(:src_images)).to eq(
            [@src_image_3, @src_image_1, src_image_4]
          )
        end

        it 'finds private gend images' do
          caption1 = FactoryGirl.create(:caption, text: 'foo')
          caption2 = FactoryGirl.create(:caption, text: 'bar')

          gend_image_4 = FactoryGirl.create(
            :gend_image,
            captions: [caption1, caption2],
            work_in_progress: false,
            private: true
          )
          gend_image_4.update!(updated_at: Time.now + 3)

          get :show, q: 'foo'

          expect(assigns(:gend_images)).to eq(
            [gend_image_4, @gend_image_3, @gend_image_1]
          )
        end

        it 'finds deleted gend images' do
          caption1 = FactoryGirl.create(:caption, text: 'foo')
          caption2 = FactoryGirl.create(:caption, text: 'bar')

          gend_image_4 = FactoryGirl.create(
            :gend_image,
            captions: [caption1, caption2],
            work_in_progress: false, is_deleted: true
          )
          gend_image_4.update!(updated_at: Time.now + 3)

          get :show, q: 'foo'

          expect(assigns(:gend_images)).to eq(
            [gend_image_4, @gend_image_3, @gend_image_1]
          )
        end

        it 'finds in progress gend images' do
          caption1 = FactoryGirl.create(:caption, text: 'foo')
          caption2 = FactoryGirl.create(:caption, text: 'bar')

          gend_image_4 = FactoryGirl.create(
            :gend_image,
            captions: [caption1, caption2],
            work_in_progress: true
          )
          gend_image_4.update!(updated_at: Time.now + 3)

          get :show, q: 'foo'

          expect(assigns(:gend_images)).to eq(
            [gend_image_4, @gend_image_3, @gend_image_1]
          )
        end

        it 'shows the gend image toolbar' do
          get(:show, q: 'foo')

          expect(assigns(:show_toolbar)).to eq(true)
        end
      end

      it 'finds src images with matching names ordered by most used' do
        get :show, q: 'foo'

        expect(assigns(:src_images)).to eq([@src_image_3, @src_image_1])
      end

      it 'finds gend images with matching captions ordered by most recent' do
        get :show, q: 'foo'

        expect(assigns(:gend_images)).to eq([@gend_image_3, @gend_image_1])
      end

      context 'src sets' do
        before do
          @src_set1 = FactoryGirl.create(
            :src_set,
            name: 'test1',
            src_images: [@src_image_1]
          )

          @src_set2 = FactoryGirl.create(
            :src_set,
            name: 'test2',
            src_images: [@src_image_1]
          )
          @src_set2.update!(updated_at: Time.now + 1)
        end

        it 'finds src sets with matching names ordered by most recent' do
          get(:show, q: 'test')
          expect(assigns(:src_sets)).to eq([@src_set2, @src_set1])
        end

        it 'does not find deleted src sets' do
          FactoryGirl.create(
            :src_set,
            name: 'test3',
            is_deleted: true,
            src_images: [@src_image_1]
          )
          get(:show, q: 'test')
          expect(assigns(:src_sets)).to eq([@src_set2, @src_set1])
        end

        it 'does not find empty src sets' do
          FactoryGirl.create(:src_set, name: 'test3')
          get(:show, q: 'test')
          expect(assigns(:src_sets)).to eq([@src_set2, @src_set1])
        end
      end
    end
  end
end
