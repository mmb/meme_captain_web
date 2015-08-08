# encoding: UTF-8

require 'rails_helper'

describe 'src_images/_src_images.html', type: :view do
  include Webrat::Matchers

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:src_images) { Kaminari.paginate_array([]).page(1) }
  let(:src_set) { FactoryGirl.create(:src_set, user: user) }

  context 'showing a set' do
    context 'when the user owns the set' do
      it 'shows the remove from set button' do
        assign :src_images, src_images
        assign :src_set, src_set
        render partial: 'src_images/src_images', locals: { current_user: user }

        expect(rendered).to contain(/Remove 0 from Set/)
      end
    end

    context "when the user doesn't own the set" do
      let(:src_set) { FactoryGirl.create(:src_set, user: user2) }

      it "doesn't show the remove from set button" do
        assign :src_images, src_images
        assign :src_set, src_set
        render partial: 'src_images/src_images', locals: { current_user: user }

        expect(rendered).to_not contain(/Remove 0 from Set/)
      end
    end

    context 'when the user is not logged in' do
      let(:user) { nil }
      let(:src_set) { FactoryGirl.create(:src_set, user: user2) }

      it "doesn't show the remove from set button" do
        assign :src_images, src_images
        assign :src_set, src_set
        render partial: 'src_images/src_images', locals: { current_user: user }

        expect(rendered).to_not contain(/Remove 0 from Set/)
      end

      it "doesn't show the toolbar" do
        assign :src_images, src_images
        assign :src_set, src_set
        render partial: 'src_images/src_images', locals: { current_user: user }

        expect(rendered).to_not have_selector '.btn-toolbar'
      end
    end

    context 'on my images pages' do
      before { allow(view).to receive(:controller_name).and_return('my') }

      it 'shows the Delete button' do
        assign :src_images, src_images
        assign :src_set, src_set
        render partial: 'src_images/src_images', locals: { current_user: user }

        expect(rendered).to contain(/Delete 0/)
      end
    end
  end
end
