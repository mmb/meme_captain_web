require 'rails_helper'

describe 'src_images/index.html.erb', type: :view do
  before do
    def view.current_user
      nil
    end
  end

  it 'renders the src images partial' do
    src_images = Kaminari.paginate_array([]).page(1)
    assign(:src_images, src_images)
    allow(view).to receive(:render).and_call_original
    expect(view).to receive(:render).with(partial: 'src_images/src_images',
                                          locals: {
                                            user: nil,
                                            show_remove_from_set: false,
                                            show_delete: false,
                                            src_images: src_images,
                                            more_images: false
                                          })
    render
  end
end
