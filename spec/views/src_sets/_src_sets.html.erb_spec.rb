# encoding: UTF-8

require 'rails_helper'

describe 'src_sets/_src_sets.html', type: :view do
  let(:src_set1) { FactoryGirl.create(:src_set) }
  let(:src_set2) { FactoryGirl.create(:src_set) }

  let(:src_sets) do
    Kaminari.paginate_array([
                              src_set1,
                              src_set2,
                              FactoryGirl.create(:src_set)
                            ]).page(1).per(2)
  end

  before do
    assign(:src_sets, src_sets)

    # kaminari paginate in the partial needs an action or it fails with
    # No route matches {:controller=>"src_sets", :page=>nil}
    controller.request.path_parameters[:action] = 'index'
  end

  it 'renders each source set' do
    allow(view).to receive(:render).and_call_original
    expect(view).to receive(:render).with(partial: src_set1)
    expect(view).to receive(:render).with(partial: src_set2)
    render(partial: 'src_sets/src_sets', locals: {
             src_sets: src_sets,
             paginate: true
           })
  end

  context 'when paginating' do
    it 'renders the page navigation' do
      expect(view).to receive(:paginate).with(src_sets)
      render(partial: 'src_sets/src_sets', locals: {
               src_sets: src_sets,
               paginate: true
             })
    end
  end

  context 'when linking to more sets' do
    it 'shows the more sets link' do
      allow(view).to receive(:link_to).and_call_original
      expect(view).to receive(:link_to).with('More sets', :src_sets)
      render(partial: 'src_sets/src_sets', locals: {
               src_sets: src_sets,
               paginate: false
             })
    end
  end
end
