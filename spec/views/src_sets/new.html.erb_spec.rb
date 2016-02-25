# encoding: UTF-8

require 'rails_helper'

describe 'src_sets/new.html.erb', type: :view do
  it 'renders' do
    assign(:src_set, FactoryGirl.create(:src_set))
    render
  end
end
