# encoding: UTF-8

require 'rails_helper'

describe 'dashboard/show.html.erb', type: :view do
  before do
    assign(:gend_images_last_24h, 7)
    assign(:src_images_last_24h, 8)
    def view.current_user
      nil
    end
  end

  it 'show the gend images created' do
    render

    expect(rendered).to have_text('7 gend images created')
    expect(rendered).to have_text('8 src images created')
  end
end
