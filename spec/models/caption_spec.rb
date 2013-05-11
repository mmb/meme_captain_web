require 'spec_helper'

describe Caption do

  it { should_not validate_presence_of :font }
  it { should allow_mass_assignment_of :font }

  it { should_not validate_presence_of :height_pct }
  it { should allow_mass_assignment_of :height_pct }

  it { should validate_presence_of :text }
  it { should allow_mass_assignment_of :text }

  it { should_not validate_presence_of :top_left_x_pct }
  it { should allow_mass_assignment_of :top_left_x_pct }

  it { should_not validate_presence_of :top_left_y_pct }
  it { should allow_mass_assignment_of :top_left_y_pct }

  it { should_not validate_presence_of :width_pct }
  it { should allow_mass_assignment_of :width_pct }

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
    subject { FactoryGirl.create(:caption, :font => font) }

    context 'when the font is nil' do
      let(:font) { nil }

      its(:font) { should eq MemeCaptainWeb::Config::DefaultFont }
    end

    context 'when the font is empty' do
      let(:font) { '' }

      its(:font) { should eq MemeCaptainWeb::Config::DefaultFont }
    end

    context 'when the font is set' do
      let(:font) { 'some_font.ttf' }

      its(:font) { should eq font }
    end

  end

end
