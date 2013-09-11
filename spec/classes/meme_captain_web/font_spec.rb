# encoding: UTF-8

require 'spec_helper'

describe 'MemeCaptainWeb::Font' do
  let(:path) { '/tmp/font.ttf' }

  let(:tables) do
    [
        double(TTFunk::Table::Cmap::Subtable, unicode?: true,
               code_map: { 1 => nil, 2 => nil }),
        double(TTFunk::Table::Cmap::Subtable, unicode?: true,
               code_map: { 3 => nil }),
    ]
  end
  let(:file) { double(TTFunk::File) }

  before do
    TTFunk::File.stub(open: file)
    file.stub_chain(:cmap, :tables) { tables }
  end

  describe '#char_set' do

    it 'builds a list of the characters in the font' do
      TTFunk::File.should_receive(:open).with(path).and_return(file)

      font = MemeCaptainWeb::Font.new(path)

      expect(font.char_set).to eq Set.new([1, 2, 3])
    end

    context 'when a subtable is not unicode' do
      let(:tables) do
        [
            double(TTFunk::Table::Cmap::Subtable, unicode?: true,
                   code_map: { 1 => nil, 2 => nil, 3 => nil }),
            double(TTFunk::Table::Cmap::Subtable, unicode?: false,
                   code_map: { 4 => nil, 5 => nil, 6 => nil }),
        ]
      end

      it 'ignores it' do
        font = MemeCaptainWeb::Font.new(path)

        expect(font.char_set).to eq Set.new([1, 2, 3])
      end
    end

  end

  describe '#path' do

    it 'returns the path' do
      font = MemeCaptainWeb::Font.new(path)
      expect(font.path).to eq path
    end

  end

  describe '#has_chars_for?' do

    context 'when the font has all of the characters' do
      let(:tables) do
        [
            double(TTFunk::Table::Cmap::Subtable, unicode?: true,
                   code_map: { 97 => nil, 98 => nil, 99 => nil, 100 => nil })
        ]
      end

      it 'has the characters' do
        font = MemeCaptainWeb::Font.new(path)

        expect(font.has_chars_for?('abc')).to be_true
      end
    end

    context 'when the font is missing some of the characters' do
      let(:tables) do
        [
            double(TTFunk::Table::Cmap::Subtable, unicode?: true,
                   code_map: { 97 => nil, 98 => nil, 99 => nil })
        ]
      end

      it 'does not have the characters' do
        font = MemeCaptainWeb::Font.new(path)

        expect(font.has_chars_for?('abcd')).to be_false
      end
    end
  end

  describe '.for' do
    let(:a_file) { double(TTFunk::File) }
    let(:b_file) { double(TTFunk::File) }

    before do
      MemeCaptainWeb::Font.instance_variable_set(:@default_fonts, nil)

      Dir.stub(glob: %w{/tmp/fonts/a.ttf /tmp/fonts/b.ttf})
      a_file.stub_chain(:cmap, :tables) { a_tables }
      b_file.stub_chain(:cmap, :tables) { b_tables }
    end

    context 'when a font has all the characters' do
      let(:a_tables) do
        [
            double(TTFunk::Table::Cmap::Subtable, unicode?: true,
                   code_map: { 97 => nil, 98 => nil, 100 => nil }),
        ]
      end

      let(:b_tables) do
        [
            double(TTFunk::Table::Cmap::Subtable, unicode?: true,
                   code_map: { 97 => nil, 98 => nil, 99 => nil }),
        ]
      end

      it 'returns the first font with the correct characters' do
        TTFunk::File.should_receive(:open).with(
            '/tmp/fonts/a.ttf').and_return(a_file)
        TTFunk::File.should_receive(:open).with(
            '/tmp/fonts/b.ttf').and_return(b_file)

        expect(MemeCaptainWeb::Font.for('abc')).to eq 'b.ttf'
      end
    end

    context 'when no fonts have all the characters' do
      let(:a_tables) do
        [
            double(TTFunk::Table::Cmap::Subtable, unicode?: true,
                   code_map: { 97 => nil, 98 => nil }),
        ]
      end

      let(:b_tables) do
        [
            double(TTFunk::Table::Cmap::Subtable, unicode?: true,
                   code_map: { 97 => nil, 98 => nil }),
        ]
      end

      it 'returns the first font' do
        TTFunk::File.should_receive(:open).with(
            '/tmp/fonts/a.ttf').and_return(a_file)
        TTFunk::File.should_receive(:open).with(
            '/tmp/fonts/b.ttf').and_return(b_file)

        expect(MemeCaptainWeb::Font.for('abc')).to eq 'a.ttf'
      end
    end
  end

  describe '.default_fonts' do
    before do
      MemeCaptainWeb::Font.instance_variable_set(:@default_fonts, nil)
    end

    it 'loads the fonts in the correct order' do
      Dir.stub(glob: %w{/tmp/fonts/b.ttf /tmp/fonts/a.ttf})

      expect(MemeCaptainWeb::Font.default_fonts.map(&:path)
      ).to eq %w{/tmp/fonts/a.ttf /tmp/fonts/b.ttf}
    end

    it 'caches the results' do
      Dir.should_receive(:glob).once.and_return(%w{tmp/fonts/a.ttf})

      2.times { MemeCaptainWeb::Font.default_fonts }
    end

  end
end
