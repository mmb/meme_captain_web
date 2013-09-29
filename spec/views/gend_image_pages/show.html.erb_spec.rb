# encoding: UTF-8

require 'spec_helper'

describe 'gend_image_pages/show.html.erb' do

  let(:gend_image) { FactoryGirl.create(:gend_image, work_in_progress: false) }
  let(:src_image) { FactoryGirl.create(:src_image) }
  let(:gend_image_url) do
    url_for(controller: :gend_images, action: :show, id: gend_image.id_hash)
  end
  let(:android) { false }

  before do
    assign(:gend_image, gend_image)
    assign(:src_image, src_image)
    assign(:gend_image_url, gend_image_url)

    view.stub_chain(:browser, :android?) { android }
  end

  context 'browser' do

    context 'when the browser is not Android' do

      it 'does not have the SMS button' do
        expect(render).to_not contain 'SMS'
      end

    end

    context 'when the browser is Android' do
      let(:android) { true }

      it 'has the SMS button' do
        expect(render).to contain 'SMS'
      end
    end
  end

  it 'has the image width' do
    expect(render).to have_selector 'img[width="399"]'
  end

  it 'has the image height' do
    expect(render).to have_selector 'img[height="399"]'
  end

end
