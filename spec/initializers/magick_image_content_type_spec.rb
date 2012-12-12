describe '#content_type' do

  it 'detects gif'

  it 'detects jpeg'

  it 'detects png' do
    img_data = Base64.decode64('iVBORw0KGgoAAAANSUhEUgAAAcwAAAAyAgMAAACsWgPIAAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wBHwQoJY1iyrwAAAAJUExURQAAAAAAAP///4Pdz9IAAAABdFJOUwBA5thmAAAAAWJLR0QB/wIt3gAAAHpJREFUWIXt1zESgCAMRNE03s9mG+9ns6e0EaKCqDOWf4sUJOHREvqciOn7Us0cEZiYmJhnc7HtVbJtS5LsVRo09DScZzmSG5iYmJit2RTVlduGquS920hFvxRMTEzMRzOv6TfKheMX9ThMTEzMnvlj5ld/S0xMTMxjNoGjc3pdi6L4AAAAAElFTkSuQmCC')
    expect(Magick::Image.from_blob(img_data)[0].content_type).to eq('image/png')
  end

end
