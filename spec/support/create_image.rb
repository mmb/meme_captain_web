def create_image(width, height, color = 'white')
  il = Magick::ImageList.new

  il.new_image(width, height) do
    self.background_color = color
  end

  il.to_blob do |i|
    i.format = 'JPEG'
  end
end
