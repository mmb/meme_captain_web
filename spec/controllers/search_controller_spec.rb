# encoding: UTF-8

require 'rails_helper'

describe SearchController, type: :controller do
  describe "GET 'show'" do
    context 'when some results are found' do
      before do
        @src_image_1 = FactoryGirl.create(
          :src_image, name: 'foo', work_in_progress: false)
        @src_image_2 = FactoryGirl.create(
          :src_image, name: 'not a match', work_in_progress: false)
        @src_image_3 = FactoryGirl.create(
          :src_image, name: 'foo2', work_in_progress: false)

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
        @gend_image_3 = FactoryGirl.create(:gend_image,
                                           captions: [caption5, caption6],
                                           work_in_progress: false,
                                           src_image: @src_image_3)
      end

      it 'finds src images with matching names ordered by most used' do
        get :show, q: 'foo'

        expect(assigns(:src_images)).to eq([@src_image_3, @src_image_1])
      end

      it 'does not find private images' do
        FactoryGirl.create(
          :src_image, name: 'foo', work_in_progress: false, private: true)
        get :show, q: 'foo'

        expect(assigns(:src_images)).to eq([@src_image_3, @src_image_1])
      end

      it 'does not find deleted images' do
        FactoryGirl.create(
          :src_image, name: 'foo', work_in_progress: false, is_deleted: true)
        get :show, q: 'foo'

        expect(assigns(:src_images)).to eq([@src_image_3, @src_image_1])
      end

      it 'does not find in progress images' do
        FactoryGirl.create(:src_image, name: 'foo')
        get :show, q: 'foo'

        expect(assigns(:src_images)).to eq([@src_image_3, @src_image_1])
      end

      it 'finds gend images with matching captions ordered by most recent' do
        get :show, q: 'foo'

        expect(assigns(:gend_images)).to eq([@gend_image_3, @gend_image_1])
      end

      it 'does not find private images' do
        caption1 = FactoryGirl.create(:caption, text: 'foo')
        caption2 = FactoryGirl.create(:caption, text: 'bar')

        FactoryGirl.create(:gend_image,
                           captions: [caption1, caption2],
                           work_in_progress: false,
                           private: true)
        get :show, q: 'foo'

        expect(assigns(:gend_images)).to eq([@gend_image_3, @gend_image_1])
      end

      it 'does not find deleted images' do
        caption1 = FactoryGirl.create(:caption, text: 'foo')
        caption2 = FactoryGirl.create(:caption, text: 'bar')
        FactoryGirl.create(:gend_image,
                           captions: [caption1, caption2],
                           work_in_progress: false, is_deleted: true)
        get :show, q: 'foo'

        expect(assigns(:gend_images)).to eq([@gend_image_3, @gend_image_1])
      end

      it 'does not find in progress images' do
        caption1 = FactoryGirl.create(:caption, text: 'foo')
        caption2 = FactoryGirl.create(:caption, text: 'bar')
        FactoryGirl.create(:gend_image,
                           captions: [caption1, caption2],
                           work_in_progress: true)
        get :show, q: 'foo'

        expect(assigns(:gend_images)).to eq([@gend_image_3, @gend_image_1])
      end
    end
  end
end
