# encoding: UTF-8

require 'rails_helper'

describe 'src_sets/index.html.erb', type: :view do
  it 'renders the src_sets partial' do
    src_sets = [FactoryGirl.create(:src_set)] * 2
    assign(:src_sets, Kaminari.paginate_array(src_sets).page(1))
    allow(view).to receive(:render).and_call_original
    expect(view).to receive(:render).with(
      partial: 'src_sets',
      locals: { src_sets: src_sets, paginate: true }
    )
    render
  end
end
