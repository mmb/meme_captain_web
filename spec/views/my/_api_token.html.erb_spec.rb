require 'rails_helper'

describe 'my/_api_token.html', type: :view do
  before do
    render(partial: 'my/api_token', locals: { current_token: current_token })
  end

  context 'when the current token is nil' do
    let(:current_token) { nil }

    it 'shows a generate button' do
      expect(rendered).to match('Generate')
    end
  end

  context 'when the current token is nil' do
    let(:current_token) { 'secret' }

    it 'show the current token' do
      expect(rendered).to match('secret')
    end

    it 'shows a regenerate button' do
      expect(rendered).to match('Regenerate')
    end
  end
end
