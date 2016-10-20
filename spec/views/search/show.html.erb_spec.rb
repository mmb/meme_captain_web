# encoding: UTF-8

require 'rails_helper'

require 'support/src_image_skip_callbacks'

describe 'search/show.html.erb', type: :view do
  let(:src_images) { [] }
  let(:src_sets) { [] }
  let(:gend_images) { [] }

  before do
    assign(:src_images, Kaminari.paginate_array(src_images).page(1))
    assign(:src_sets, Kaminari.paginate_array(src_sets).page(1))
    assign(:gend_images, Kaminari.paginate_array(gend_images).page(1))
    assign(:show_toolbar, true)
    allow(view).to receive(:render).and_call_original
    def view.current_user
      nil
    end
  end

  context 'when there are no src images' do
    let(:src_images) { [] }
    it 'does not render the src images partial' do
      expect(view).to_not receive(:render).with(
        partial: 'src_images/src_images'
      )
      render
    end
  end

  context 'when there are src images' do
    let(:src_images) do
      src_image1 = FactoryGirl.create(
        :src_image,
        work_in_progress: false,
        src_thumb: FactoryGirl.create(:src_thumb)
      )
      src_image1.set_derived_image_fields
      src_image2 = FactoryGirl.create(
        :src_image,
        work_in_progress: false,
        src_thumb: FactoryGirl.create(:src_thumb)
      )
      src_image2.set_derived_image_fields
      [src_image1, src_image2]
    end

    it 'renders the src images partial' do
      expect(view).to receive(:render).with(partial: 'src_images/src_images',
                                            locals: {
                                              user: nil,
                                              show_remove_from_set: false,
                                              show_delete: false,
                                              src_images: src_images,
                                              more_images: false
                                            })
      render
    end
  end

  context 'when there are no src sets' do
    let(:src_sets) { [] }
    it 'does not render the src sets partial' do
      expect(view).to_not receive(:render).with(partial: 'src_sets/src_sets')
      render
    end
  end

  context 'when there are src sets' do
    let(:src_sets) { [FactoryGirl.create(:src_set)] * 2 }

    it 'renders the src sets partial' do
      expect(view).to receive(:render).with(
        partial: 'src_sets/src_sets',
        locals: { src_sets: src_sets, paginate: true }
      )
      render
    end
  end

  context 'when there are no gend images' do
    let(:gend_images) { [] }
    it 'does not render the gend images partial' do
      expect(view).to_not receive(:render).with(
        partial: 'gend_images/gend_images'
      )
      render
    end
  end

  context 'when there are gend images' do
    let(:gend_images) { [FactoryGirl.create(:gend_image)] * 2 }

    it 'renders the gend images' do
      expect(view).to receive(:render).with(
        partial: 'gend_images/gend_images',
        locals: { gend_images: gend_images, show_toolbar: true }
      )
      render
    end

    context 'when show_toolbar is false' do
      before do
        assign(:show_toolbar, false)
      end

      it 'renders gend images with show_toolbar false' do
        expect(view).to receive(:render).with(
          partial: 'gend_images/gend_images',
          locals: { gend_images: gend_images, show_toolbar: false }
        )
        render
      end
    end
  end
end
