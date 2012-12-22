require 'spec_helper'

describe '#content_type' do

  let(:jpeg) {
    Magick::ImageList.new(Rails.root + 'spec/fixtures/files/ti_duck.jpg')[0]
  }

  let(:png) {
    img_data = Base64.decode64('iVBORw0KGgoAAAANSUhEUgAAAcwAAAAyAgMAAACsWgPIAAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wBHwQoJY1iyrwAAAAJUExURQAAAAAAAP///4Pdz9IAAAABdFJOUwBA5thmAAAAAWJLR0QB/wIt3gAAAHpJREFUWIXt1zESgCAMRNE03s9mG+9ns6e0EaKCqDOWf4sUJOHREvqciOn7Us0cEZiYmJhnc7HtVbJtS5LsVRo09DScZzmSG5iYmJit2RTVlduGquS920hFvxRMTEzMRzOv6TfKheMX9ThMTEzMnvlj5ld/S0xMTMxjNoGjc3pdi6L4AAAAAElFTkSuQmCC')
    Magick::Image.from_blob(img_data)[0]
  }

  it 'detects gif'

  it 'detects jpeg' do
    expect(jpeg.content_type).to eq 'image/jpeg'
  end

  it 'detects png' do
    expect(png.content_type).to eq 'image/png'
  end

end
