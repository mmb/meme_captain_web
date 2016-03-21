# encoding: UTF-8

require 'rails_helper'

describe 'dashboard/show.html.erb', type: :view do
  before do
    assign(:gend_image_successes_last_24h, 9999)
    assign(:gend_image_errors_last_24h, 1)
    assign(:gend_image_success_rate_last_24h, 99.99)
    assign(:src_images_last_24h, 8)
    assign(:new_users_last_24h, 9)
    assign(:no_result_searches, [
             instance_double(NoResultSearch, query: 'q1'),
             instance_double(NoResultSearch, query: 'q2')
           ])
    def view.current_user
      nil
    end
  end

  it 'shows the gend images successfully created' do
    render

    expect(rendered).to have_text('9999 gend images created')
  end

  it 'shows the gend image errors' do
    render

    expect(rendered).to have_text('1 errors')
  end

  it 'shows the gend image success rate' do
    render

    expect(rendered).to have_text('99.99%')
  end

  it 'shows the src images created' do
    render

    expect(rendered).to have_text('8 src images created')
  end

  it 'shows the users created' do
    render

    expect(rendered).to have_text('9 users created')
  end

  it 'shows the last 10 no result searches' do
    render

    expect(rendered).to have_text('q1')
    expect(rendered).to have_text('q2')
  end
end
