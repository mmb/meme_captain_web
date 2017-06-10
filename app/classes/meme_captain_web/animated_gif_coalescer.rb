# frozen_string_literal: true

require 'open3'

module MemeCaptainWeb
  # Coalesce large animated gifs without loading them with rmagick.
  class AnimatedGifCoalescer
    def coalesce(data)
      command = 'convert - -coalesce -'.freeze
      Open3.popen3(command) do |i, o, e, t|
        i.binmode
        o.binmode
        i.write(data)
        i.close_write
        out_data = o.read
        raise(e.read) unless t.value.success?
        out_data
      end
    end
  end
end
