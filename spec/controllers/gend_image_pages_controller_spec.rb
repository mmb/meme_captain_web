require 'spec_helper'

describe GendImagePagesController do

  describe 'show' do

    let(:src_image) { FactoryGirl.create(:src_image) }
    let(:gend_image) { FactoryGirl.create(:gend_image, src_image: src_image) }

    subject { get :show, id: gend_image.id_hash }

    it 'sets the gend image' do
      subject
      expect(assigns(:gend_image)).to eq gend_image
    end

    it 'sets the src image' do
      subject
      expect(assigns(:src_image)).to eq src_image
    end

    context 'when the gend image is less than 10 seconds old' do
      it 'refreshes in 2 seconds' do
        subject
        expect(assigns(:refresh_in)).to eq 2
      end
    end

    context 'when the gend image is more than 10 seconds old' do
      it 'does not refresh' do
        gend_image

        Timecop.freeze(20) do
          subject
          expect(assigns(:refresh_in)).to be_nil
        end

      end
    end

  end
end