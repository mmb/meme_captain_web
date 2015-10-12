describe 'clipboard', ->
  describe 'Clipboard', ->
    describe '#last_if_image', ->
      clipboard = new Clipboard

      describe 'when there are no clipboard items', ->
        it 'returns undefined', ->
          clipboard = new Clipboard
          event = clipboardData:
            items: []
          expect(clipboard.last_if_image(event)).toBeUndefined()

      describe 'when the last clipboard item is not an image', ->
        it 'returns undefined', ->
          clipboard = new Clipboard
          event = clipboardData:
            items: [{ type: 'not' }, { type: 'image' }]
          expect(clipboard.last_if_image(event)).toBeUndefined()

      describe 'when the last clipboard item is an image', ->
        it 'returns the image item', ->
          clipboard = new Clipboard
          last_item = { type: 'image', getAsFile: -> 'fake file' }
          event = clipboardData:
            items: [last_item, { type: 'not' }]
          expect(clipboard.last_if_image(event)).toEqual('fake file')
