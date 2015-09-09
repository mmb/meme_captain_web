# encoding: UTF-8

require 'rails_helper'

describe 'terms/index.html.erb', type: :view do
  it 'sets the content for the title' do
    expect(view).to receive(:content_for).with(:title) do |&block|
      expect(block.call).to eq('Meme Captain Terms of Service')
    end
    render
  end
end
