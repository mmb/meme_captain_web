# frozen_string_literal: true

module MemeCaptainWeb
  # Remove every other frame from an animated gif to reduce its size.
  class AnimatedGifTrimmer
    include IoCopier

    def initialize
      @removed_delay_times = []
    end

    def trim(data)
      reset(data)

      read_metadata

      @writing_now = true
      until done?
        next if application_extension? || comment?
        next if graphics_control_extension?
        read_image
        change_writing_now
      end

      string
    end

    private

    def read_metadata
      read(6, and_write: true) # header
      global_color_table_bytes = read_logical_screen_descriptor
      read(global_color_table_bytes, and_write: true)
    end

    def done?
      if_next_bytes(0x3B) { |data| write(data) }
    end

    def application_extension?
      if_next_bytes(0x21, 0xFF) do |data|
        write(data)
        read(12, and_write: true)
        read_blocks(and_write: true)
      end
    end

    def comment?
      if_next_bytes(0x21, 0xFE) { read_blocks }
    end

    def graphics_control_extension?
      if_next_bytes(0x21, 0xF9) do |data|
        write(data) if @writing_now
        read_delay_time
        read(2, and_write: @writing_now)
      end
    end

    def read_image
      local_color_table_bytes = read_image_descriptor
      read(local_color_table_bytes, and_write: @writing_now)
      read_image_data
    end

    def change_writing_now
      if @writing_now
        @writing_now = false
        @removed_delay_times = []
      elsif !@removed_delay_times.empty?
        @writing_now = true
      end
    end

    def read_logical_screen_descriptor
      read(4, and_write: true)
      field = read(1, and_write: true).unpack('C'.freeze).first
      read(2, and_write: true)
      color_table_bytes(field)
    end

    def read_delay_time
      read(2, and_write: @writing_now)
      delay_time = read(2).unpack('v'.freeze).first
      if @writing_now
        new_delay_time = delay_time + @removed_delay_times.reduce(0, :+)
        write([new_delay_time].pack('v'.freeze))
      else
        @removed_delay_times << delay_time
      end
    end

    def read_image_descriptor
      read(9, and_write: @writing_now)
      field = read(1, and_write: @writing_now).unpack('C'.freeze).first
      color_table_bytes(field)
    end

    def read_image_data
      read(1, and_write: @writing_now)
      read_blocks(and_write: @writing_now)
    end

    def read_blocks(options = {})
      loop do
        block_size = read(1, options).unpack('C'.freeze).first
        break if block_size.zero?
        read(block_size, options)
      end
    end

    def color_table_bytes(field)
      if field & 128 > 0
        3 * 2**((field & 7) + 1)
      else
        0
      end
    end
  end
end
