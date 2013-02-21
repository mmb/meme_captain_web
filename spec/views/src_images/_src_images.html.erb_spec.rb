require 'spec_helper'

describe 'src_images/_src_images.html' do

  subject {
    render :partial => 'src_images/src_images',
           :locals => {:current_user => user}
  }

  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:src_images) { Kaminari.paginate_array([]).page(1) }

  context 'showing a set' do

    context 'when the user owns the set' do
      let(:src_set) { FactoryGirl.create(:src_set, :user => user) }

      it 'shows the remove from set button' do
        assign :src_images, src_images
        assign :src_set, src_set
        subject

        expect(rendered).to contain /Remove 0 from Set/
      end

    end

    context "when the user doesn't own the set" do
      let(:src_set) { FactoryGirl.create(:src_set, :user => user2) }

      it "doesn't show the remove from set button" do
        assign :src_images, src_images
        assign :src_set, src_set
        subject

        expect(rendered).to_not contain /Remove 0 from Set/
      end

    end

    context "when the user is not logged in" do
      let(:user) { nil }
      let(:src_set) { FactoryGirl.create(:src_set, :user => user2) }

      it "doesn't show the remove from set button" do
        assign :src_images, src_images
        assign :src_set, src_set
        subject

        expect(rendered).to_not contain /Remove 0 from Set/
      end

      it "doesn't show the toolbar" do
        assign :src_images, src_images
        assign :src_set, src_set
        subject

        expect(rendered).to_not have_selector '.btn-toolbar'
      end
    end

  end

end
