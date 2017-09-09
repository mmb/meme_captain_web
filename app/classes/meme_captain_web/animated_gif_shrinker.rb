# frozen_string_literal: true

module MemeCaptainWeb
  # Try to reduce the size of large animated gifs.
  class AnimatedGifShrinker
    def initialize(coalescer, trimmer)
      @coalescer = coalescer
      @trimmer = trimmer
    end

    def shrink(data, max_size)
      return if data.size <= max_size

      trimmed_data = @coalescer.coalesce(data)
      while trimmed_data.size > max_size
        trimmed_data = @trimmer.trim(trimmed_data)
      end
      yield trimmed_data
      nil
    end
  end
end
