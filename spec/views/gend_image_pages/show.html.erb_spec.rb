require 'spec_helper'

describe "gend_image_pages/show.html.erb" do

  let(:gend_image) { FactoryGirl.create(:gend_image, :work_in_progress => false) }
  let(:src_image) { FactoryGirl.create(:src_image) }
  let(:gend_image_url) {
    url_for(:controller => :gend_images, :action => :show, :id => gend_image.id_hash)
  }
  let(:android) { false }

  before do
    assign(:gend_image, gend_image)
    assign(:src_image, src_image)
    assign(:gend_image_url, gend_image_url)

    view.stub_chain(:browser, :android?) { android }
  end

  subject { render }

  context 'browser' do

    context 'when the browser is not Android' do
      it { should_not contain('SMS') }
    end

    context 'when the browser is Android' do
      let(:android) { true }

      it { should contain('SMS') }
    end
  end

  it { should have_selector 'img[width="399"]' }

  it { should have_selector 'img[height="399"]' }

end
