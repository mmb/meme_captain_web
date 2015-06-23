describe 'quick_add_url', ->
  beforeEach ->
    loadFixtures 'quick_add_url.html'
    window.quick_add_url_init()

  describe 'loading an image from a url', ->
    describe 'when the API returns success', ->
      xit 'informs the user that url was successfully submitted'
      describe 'when the image is finished within the polling window', ->
        xit "redirects to the new image's meme creation page"
      describe 'when the image does not finish within the polling window', ->
        xit 'informs the user that there was an error loading the url'
    describe 'when the url is empty', ->
      beforeEach ->
        $('#quick-add-url').val('')

      it 'does not submit an AJAX request', ->
        ajax_spy = spyOn($, 'ajax')

        e = $.Event('keypress')
        e.which = 13
        $('#quick-add-url').trigger(e)
        expect(ajax_spy).not.toHaveBeenCalled()
