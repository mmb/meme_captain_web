# encoding: UTF-8

require 'rails_helper'

describe 'src_images/index.html.erb', type: :view do
  it 'renders the src images partial' do
    assign(:src_images, Kaminari.paginate_array([]).page(1))
    allow(view).to receive(:render).and_call_original
    expect(view).to receive(:render).with(partial: 'src_images/src_images')
    render
  end
end
