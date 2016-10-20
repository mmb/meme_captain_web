# encoding: UTF-8

require 'rails_helper'

require 'support/gend_image_skip_callbacks'

describe PendingGendImagesHelper, type: :helper do
  describe '#pending_gend_thumb_url_for' do
    let(:gend_image) { FactoryGirl.create(:finished_gend_image) }

    it 'generates the pending gend image url' do
      expected = "/pending_gend_images/#{gend_image.id_hash}"

      expect(helper.pending_gend_image_url_for(gend_image)).to eq(expected)
    end
  end
end
