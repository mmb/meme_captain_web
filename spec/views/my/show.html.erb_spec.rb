# encoding: UTF-8

require 'rails_helper'

describe 'my/show.html.erb', type: :view do
  let(:src_sets) { [] }

  before do
    assign(:gend_images, Kaminari.paginate_array([]).page(1))
    assign(:src_images, Kaminari.paginate_array([]).page(1))
    assign(:src_sets, Kaminari.paginate_array(src_sets).page(1))
    assign(:show_toolbar, true)
    def view.current_user
      nil
    end
  end

  it 'sets the content for the title' do
    expect(view).to receive(:content_for).with(:title) do |&block|
      expect(block.call).to eq('Meme Captain My Images')
    end
    render
  end

  context 'when there are src sets' do
    let(:src_sets) { [FactoryGirl.create(:src_set)] * 2 }

    it 'renders the src sets partial' do
      allow(view).to receive(:render).and_call_original
      expect(view).to receive(:render).with(
        partial: 'src_sets/src_sets',
        locals: { src_sets: src_sets, paginate: true })
      render
    end
  end

  it 'renders the API token partial' do
    assign(:api_token, 'secret')
    allow(view).to receive(:render).and_call_original
    expect(view).to receive(:render).with(
      partial: 'api_token',
      locals: { current_token: 'secret' })
    render
  end
end
