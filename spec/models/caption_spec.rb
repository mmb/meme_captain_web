# encoding: UTF-8

require 'spec_helper'

describe Caption do

  it { should_not validate_presence_of :font }

  it { should_not validate_presence_of :height_pct }

  it { should validate_presence_of :text }

  it { should_not validate_presence_of :top_left_x_pct }

  it { should_not validate_presence_of :top_left_y_pct }

  it { should_not validate_presence_of :width_pct }

  it { should belong_to :gend_image }

  context 'converting to a MemeCaptain::TextPos' do

    let(:caption) { FactoryGirl.create(:caption) }

    subject { caption.text_pos }

    its(:text) { should == caption.text }
    its(:x) { should == caption.top_left_x_pct }
    its(:y) { should == caption.top_left_y_pct }
    its(:width) { should == caption.width_pct }
    its(:height) { should == caption.height_pct }

    it 'has the correct font' do
      expect(subject.draw_options[:font]).to include caption.font
    end

  end

  describe '#default_values' do

    context 'when the font is nil' do

      it 'uses the default font' do
        MemeCaptainWeb::Font.stub(for: 'font.ttf')
        caption = FactoryGirl.create(:caption, font: nil)
        expect(caption.font).to eq 'font.ttf'
      end

    end

    context 'when the font is empty' do

      it 'uses the default font' do
        MemeCaptainWeb::Font.stub(for: 'font.ttf')
        caption = FactoryGirl.create(:caption, font: '')
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

end
