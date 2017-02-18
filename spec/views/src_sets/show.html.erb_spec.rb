require 'rails_helper'

describe 'src_sets/show.html.erb', type: :view do
  let(:src_set) { FactoryGirl.create(:src_set) }

  before do
    assign(:src_set, src_set)
    assign(:src_images, Kaminari.paginate_array([]).page(1))
    def view.current_user
      nil
    end
  end

  it 'has the src set name in the title' do
    render

    expect(view.content_for(:title)).to eq "#{src_set.name} memes"
  end
end
