# encoding: UTF-8

require 'set'
require 'ttfunk'

module MemeCaptainWeb
  # Font class.
  class Font
    attr_reader :char_set
    attr_reader :path

    # For captions with no font specified, all .ttf files in Rails.root/fonts/
    # will be checked in lexical order and the first font with all of the
    # required characters will be used. If none have all of the characters, the
    # first one will be used.

    def self.for(text)
      best_font = default_fonts.find { |f| f.has_chars_for?(text) } ||
          default_fonts.first
      File.basename(best_font.path)
    end

    @default_fonts = nil

    def self.default_fonts
      return @default_fonts if @default_fonts

      font_paths = Dir.glob("#{Rails.root}/fonts/*.ttf")
      font_paths = font_paths.sort_by { |p| File.basename(p) }
      @default_fonts = font_paths.map { |font_path| Font.new(font_path) }
    end

    def initialize(path)
      @path = path
      @char_set = get_char_set
    end

    def has_chars_for?(text)
      Set.new(text.chars.map(&:ord)).subset?(char_set)
    end

    private

    def get_char_set
      file = TTFunk::File.open(path)

      unicode_subtables = file.cmap.tables.select(&:unicode?)

      @char_set = unicode_subtables.reduce(Set.new) do |char_set, subtable|
        char_set.merge(subtable.code_map.keys)
      end
    end
  end
end
