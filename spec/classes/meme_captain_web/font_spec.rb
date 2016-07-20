# encoding: UTF-8

require 'rails_helper'

describe 'MemeCaptainWeb::Font' do
  let(:path) { '/tmp/font.ttf' }

  let(:tables) do
    [
      double(TTFunk::Table::Cmap::Subtable,
             unicode?: true,
             code_map: {
               1 => nil,
               2 => nil
             }),
      double(TTFunk::Table::Cmap::Subtable,
             unicode?: true,
             code_map: {
               3 => nil
             })
    ]
  end
  let(:cmap) { instance_double('TTFunk::Table::Cmap') }
  let(:file) { instance_double('TTFunk::File') }

  before do
    allow(TTFunk::File).to receive(:open).with(path).and_return(file)
    allow(file).to receive(:cmap).with(no_args).and_return(cmap)
    allow(cmap).to receive(:tables).with(no_args).and_return(tables)
  end

  describe '#char_set' do
    it 'builds a list of the characters in the font' do
      expect(TTFunk::File).to receive(:open).with(path).and_return(file)

      font = MemeCaptainWeb::Font.new(path)

      expect(font.char_set).to eq Set.new([1, 2, 3])
    end

    context 'when a subtable is not unicode' do
      let(:tables) do
        [
          double(TTFunk::Table::Cmap::Subtable,
                 unicode?: true,
                 code_map: {
                   1 => nil,
                   2 => nil,
                   3 => nil
                 }),
          double(TTFunk::Table::Cmap::Subtable,
                 unicode?: false,
                 code_map: {
                   4 => nil,
                   5 => nil,
                   6 => nil
                 })
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

  describe '#chars_for?' do
    context 'when the font has all of the characters' do
      let(:tables) do
        [
          double(TTFunk::Table::Cmap::Subtable,
                 unicode?: true,
                 code_map: {
                   97 => nil,
                   98 => nil,
                   99 => nil,
                   100 => nil
                 })
        ]
      end

      it 'has the characters' do
        font = MemeCaptainWeb::Font.new(path)

        expect(font.chars_for?('abc')).to eq(true)
      end
    end

    context 'when the font is missing some of the characters' do
      let(:tables) do
        [
          double(TTFunk::Table::Cmap::Subtable,
                 unicode?: true,
                 code_map: {
                   97 => nil,
                   98 => nil,
                   99 => nil
                 })
        ]
      end

      it 'does not have the characters' do
        font = MemeCaptainWeb::Font.new(path)

        expect(font.chars_for?('abcd')).to eq(false)
      end
    end
  end

  describe '.for' do
    let(:a_file) { instance_double('TTFunk::File') }
    let(:b_file) { instance_double('TTFunk::File') }

    let(:a_cmap) { instance_double('TTFunk::Table::Cmap') }
    let(:b_cmap) { instance_double('TTFunk::Table::Cmap') }

    before do
      MemeCaptainWeb::Font.instance_variable_set(:@default_fonts, nil)

      allow(Dir).to receive(:glob).with("#{Rails.root}/fonts/*.ttf").and_return(
        %w(/tmp/fonts/a.ttf /tmp/fonts/b.ttf)
      )
      allow(a_file).to receive(:cmap).with(no_args).and_return(a_cmap)
      allow(a_cmap).to receive(:tables).with(no_args).and_return(a_tables)

      allow(b_file).to receive(:cmap).with(no_args).and_return(b_cmap)
      allow(b_cmap).to receive(:tables).with(no_args).and_return(b_tables)
    end

    context 'when a font has all the characters' do
      let(:a_tables) do
        [
          double(TTFunk::Table::Cmap::Subtable,
                 unicode?: true,
                 code_map: {
                   97 => nil,
                   98 => nil,
                   100 => nil
                 })
        ]
      end

      let(:b_tables) do
        [
          double(TTFunk::Table::Cmap::Subtable,
                 unicode?: true,
                 code_map: {
                   97 => nil,
                   98 => nil,
                   99 => nil
                 })
        ]
      end

      it 'returns the first font with the correct characters' do
        expect(TTFunk::File).to receive(:open).with(
          '/tmp/fonts/a.ttf'
        ).and_return(a_file)
        expect(TTFunk::File).to receive(:open).with(
          '/tmp/fonts/b.ttf'
        ).and_return(b_file)

        expect(MemeCaptainWeb::Font.for('abc')).to eq 'b.ttf'
      end

      context 'when the text contains whitespace that will be filtered out' do
        let(:b_tables) do
          [
            double(TTFunk::Table::Cmap::Subtable,
                   unicode?: true,
                   code_map: {
                     32 => nil,
                     97 => nil,
                     98 => nil,
                     99 => nil
                   })
          ]
        end

        it 'does not require the font to contains the whitespace characters' do
          expect(TTFunk::File).to receive(:open).with(
            '/tmp/fonts/a.ttf'
          ).and_return(a_file)
          expect(TTFunk::File).to receive(:open).with(
            '/tmp/fonts/b.ttf'
          ).and_return(b_file)

          expect(MemeCaptainWeb::Font.for("abc\f\n\r\tabc")).to eq 'b.ttf'
        end
      end
    end

    context 'when no fonts have all the characters' do
      let(:a_tables) do
        [
          double(TTFunk::Table::Cmap::Subtable,
                 unicode?: true,
                 code_map: {
                   97 => nil,
                   98 => nil
                 })
        ]
      end

      let(:b_tables) do
        [
          double(TTFunk::Table::Cmap::Subtable,
                 unicode?: true,
                 code_map: {
                   97 => nil,
                   98 => nil
                 })
        ]
      end

      it 'returns the first font' do
        expect(TTFunk::File).to receive(:open).with(
          '/tmp/fonts/a.ttf'
        ).and_return(a_file)
        expect(TTFunk::File).to receive(:open).with(
          '/tmp/fonts/b.ttf'
        ).and_return(b_file)

        expect(MemeCaptainWeb::Font.for('abc')).to eq 'a.ttf'
      end
    end
  end

  describe '.default_fonts' do
    before do
      MemeCaptainWeb::Font.instance_variable_set(:@default_fonts, nil)
    end

    it 'loads the fonts in the correct order' do
      allow(Dir).to receive(:glob).with("#{Rails.root}/fonts/*.ttf").and_return(
        %w(/tmp/fonts/a.ttf /tmp/fonts/b.ttf)
      )
      allow(TTFunk::File).to receive(:open).with(
        '/tmp/fonts/a.ttf'
      ).and_return(file)
      allow(TTFunk::File).to receive(:open).with(
        '/tmp/fonts/b.ttf'
      ).and_return(file)

      expect(MemeCaptainWeb::Font.default_fonts.map(&:path))
        .to eq %w(/tmp/fonts/a.ttf /tmp/fonts/b.ttf)
    end

    it 'caches the results' do
      allow(Dir).to receive(:glob).with(
        "#{Rails.root}/fonts/*.ttf"
      ).once.and_return(
        %w(/tmp/fonts/a.ttf)
      )
      allow(TTFunk::File).to receive(:open).with(
        '/tmp/fonts/a.ttf'
      ).once.and_return(file)

      2.times { MemeCaptainWeb::Font.default_fonts }
    end
  end
end
