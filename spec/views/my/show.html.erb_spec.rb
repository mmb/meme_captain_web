# encoding: UTF-8

require 'rails_helper'

describe 'my/show.html.erb', type: :view do
  include Webrat::Matchers

  before do
    assign(:gend_images, Kaminari.paginate_array([]).page(1))
    assign(:src_images, Kaminari.paginate_array([]).page(1))
    assign(:src_sets, Kaminari.paginate_array([]).page(1))
    assign(:show_toolbar, true)
  end

  it 'sets the content for the title' do
    expect(view).to receive(:content_for).with(:title) do |&block|
      expect(block.call).to eq('Meme Captain My Images')
    end
    render
  end
end
