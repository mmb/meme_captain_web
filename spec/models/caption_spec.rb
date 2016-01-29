# encoding: UTF-8

require 'rails_helper'

describe Caption do
  it { should_not validate_presence_of :font }

  it { should validate_presence_of :height_pct }

  it { should validate_presence_of :text }

  it { should validate_presence_of :top_left_x_pct }

  it { should validate_presence_of :top_left_y_pct }

  it { should validate_presence_of :width_pct }

  it { should belong_to :gend_image }

  context 'converting to a MemeCaptain::TextPos' do
    let(:caption) { FactoryGirl.create(:caption, text: 'TEST') }

    subject(:text_pos) { caption.text_pos }

    specify { expect(text_pos.text).to eq(caption.text) }
    specify { expect(text_pos.x).to eq(caption.top_left_x_pct) }
    specify { expect(text_pos.y).to eq(caption.top_left_y_pct) }
    specify { expect(text_pos.width).to eq(caption.width_pct) }
    specify { expect(text_pos.height).to eq(caption.height_pct) }

    it 'has the correct font' do
      expect(subject.draw_options[:font]).to include caption.font
    end

    context 'when the text has lowercase letters' do
      let(:caption) { FactoryGirl.create(:caption, text: 'AbCdEfG') }

      it 'converts all characters to uppercase' do
        expect(text_pos.text).to eq('ABCDEFG')
      end
    end

    context 'when the text has lowercase non-ascii letters' do
      let(:caption) { FactoryGirl.create(:caption, text: 'àbçdêfG') }

      it 'converts all characters to uppercase' do
        expect(text_pos.text).to eq('ÀBÇDÊFG')
      end
    end

    context 'when the text has emoji modifiers' do
      let(:caption) { FactoryGirl.create(:caption, text: '🏼') }

      it 'does not blow up twitter cldr' do
        pending('twitter cldr supports emoji modifiers')
        expect(text_pos.text).to eq('🏼')
      end
    end
  end

  describe '#default_values' do
    context 'when the font is nil' do
      it 'uses the default font' do
        allow(MemeCaptainWeb::Font).to receive(:for).with(
          'TEST').and_return('font.ttf')
        caption = FactoryGirl.create(:caption, text: 'TEST', font: nil)
        expect(caption.font).to eq 'font.ttf'
      end
    end

    context 'when the font is empty' do
      it 'uses the default font' do
        allow(MemeCaptainWeb::Font).to receive(:for).with(
          'TEST').and_return('font.ttf')
        caption = FactoryGirl.create(:caption, text: 'TEST', font: '')
        expect(caption.font).to eq 'font.ttf'
      end
    end

    context 'when the font is set' do
      it 'uses the font provided' do
        caption = FactoryGirl.create(:caption, font: 'some_font.ttf')
        expect(caption.font).to eq 'some_font.ttf'
      end
    end
  end

  context 'when the text is longer than 255 characters' do
    it 'does not raise an exception' do
      expect do
        FactoryGirl.create(:caption, text: 'a' * 256)
      end.to_not raise_error
    end
  end
end
