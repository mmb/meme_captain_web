module MemeCaptainWeb
  # Mixin for conditionally copying data from one IO to another.
  module IoCopier
    extend Forwardable
    def_delegators :@out_io, :string, :write

    def reset(data)
      @in_io = StringIO.new(data)
      @out_io = StringIO.new
    end

    def read(num_bytes, options = {})
      @in_io.read(num_bytes).tap do |data|
        @out_io.write(data) if options[:and_write]
      end
    end

    def if_next_bytes(*bytes)
      num_bytes = bytes.size
      data = read(num_bytes)
      if data.unpack("C#{num_bytes}") == bytes
        yield data
        true
      else
        @in_io.seek(-num_bytes, IO::SEEK_CUR)
        false
      end
    end
  end
end
