# encoding: UTF-8

require 'rails_helper'

describe SearchController, type: :controller do
  describe "GET 'show'" do
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
          'https://www.google.com/search?q=test+meme+template&tbm=isch')
      end

      it 'correctly encodes google_search_url' do
        get :show, q: '<hi&>'
        expect(assigns(:google_search_url)).to eq(
          'https://www.google.com/search?q=%3Chi%26%3E+meme+template&tbm=isch')
      end
    end

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
        Timecop.travel(Time.now + 1)
        @gend_image_2 = FactoryGirl.create(:gend_image,
                                           captions: [caption3, caption4],
                                           work_in_progress: false,
                                           src_image: @src_image_3)
        Timecop.travel(Time.now + 1)
        @gend_image_3 = FactoryGirl.create(:gend_image,
                                           captions: [caption5, caption6],
                                           work_in_progress: false,
                                           src_image: @src_image_3)
        Timecop.return
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
