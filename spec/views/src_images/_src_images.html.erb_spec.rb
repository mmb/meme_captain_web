# encoding: UTF-8

require 'rails_helper'

describe 'src_images/_src_images.html', type: :view do
  let(:user) { nil }
  let(:show_remove_from_set) { false }
  let(:show_delete) { false }
  let(:more_images) { false }
  let(:src_image) { FactoryGirl.create(:finished_src_image) }
  let(:src_images) do
    Kaminari.paginate_array([
                              src_image,
                              FactoryGirl.create(:finished_src_image)
                            ]).page(1).per(1)
  end

  before do
    # kaminari paginate in the partial needs an action or it fails with
    # No route matches {:controller=>"src_images", :page=>nil}
    controller.request.path_parameters[:action] = 'index'
  end

  context 'when the user is logged in' do
    let(:user) { FactoryGirl.create(:user) }

    it 'shows the toolbar' do
      render(partial: 'src_images/src_images', locals: {
               user: user,
               show_remove_from_set: show_remove_from_set,
               show_delete: show_delete,
               src_images: src_images,
               more_images: more_images
             })

      expect(rendered).to have_selector('.btn-toolbar')
    end

    context 'when the remove from set button should be shown' do
      let(:show_remove_from_set) { true }

      it 'shows the remove from set button' do
        render(partial: 'src_images/src_images', locals: {
                 user: user,
                 show_remove_from_set: show_remove_from_set,
                 show_delete: show_delete,
                 src_images: src_images,
                 more_images: more_images
               })

        expect(rendered).to have_text('Remove 0 from Set')
      end
    end

    context 'when the remove from set button should not be shown' do
      let(:show_remove_from_set) { false }

      it 'does not show the remove from set button' do
        render(partial: 'src_images/src_images', locals: {
                 user: user,
                 show_remove_from_set: show_remove_from_set,
                 show_delete: show_delete,
                 src_images: src_images,
                 more_images: more_images
               })

        expect(rendered).to_not have_text('Remove 0 from Set')
      end
    end

    context 'when the delete button should be shown' do
      let(:show_delete) { true }

      it 'shows the delete button' do
        render(partial: 'src_images/src_images', locals: {
                 user: user,
                 show_remove_from_set: show_remove_from_set,
                 show_delete: show_delete,
                 src_images: src_images,
                 more_images: more_images
               })

        expect(rendered).to have_text('Delete 0')
      end
    end

    context 'when the delete button should not be shown' do
      let(:show_delete) { false }

      it 'does not show the delete button' do
        render(partial: 'src_images/src_images', locals: {
                 user: user,
                 show_remove_from_set: show_remove_from_set,
                 show_delete: show_delete,
                 src_images: src_images,
                 more_images: more_images
               })

        expect(rendered).to_not have_text('Delete 0')
      end
    end
  end

  context 'when the user is not logged in' do
    let(:user) { nil }

    it 'does not show the toolbar' do
      render(partial: 'src_images/src_images', locals: {
               user: user,
               show_remove_from_set: show_remove_from_set,
               show_delete: show_delete,
               src_images: src_images,
               more_images: more_images
             })

      expect(rendered).to_not have_selector('.btn-toolbar')
    end
  end

  it 'show the src images' do
    render(partial: 'src_images/src_images', locals: {
             user: user,
             show_remove_from_set: show_remove_from_set,
             show_delete: show_delete,
             src_images: src_images,
             more_images: more_images
           })

    expect(rendered).to have_selector(
      "img[src='/src_thumbs/#{src_image.src_thumb.id}" \
      ".#{src_image.src_thumb.format}']"
    )
  end

  context 'when the more images link should be shown' do
    let(:more_images) { true }

    it 'shows the more images link' do
      render(partial: 'src_images/src_images', locals: {
               user: user,
               show_remove_from_set: show_remove_from_set,
               show_delete: show_delete,
               src_images: src_images,
               more_images: more_images
             })

      expect(rendered).to have_text('More images')
    end
  end

  context 'when the more images link should not be shown' do
    let(:more_images) { false }

    it 'shows the page navigator' do
      render(partial: 'src_images/src_images', locals: {
               user: user,
               show_remove_from_set: show_remove_from_set,
               show_delete: show_delete,
               src_images: src_images,
               more_images: more_images
             })

      expect(rendered).to have_selector('ul.pagination')
    end
  end
end
