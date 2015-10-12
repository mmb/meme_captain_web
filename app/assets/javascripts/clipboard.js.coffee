class @Clipboard

  last_if_image: (event) ->
    last_item = event.clipboardData.items[0]
    if last_item? and ~last_item.type.indexOf('image')
      return last_item.getAsFile()
