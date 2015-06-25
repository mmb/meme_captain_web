describe 'src_images', ->
  beforeEach ->
    loadFixtures 'src_images.html'
    window.load_urls_init()

  describe 'creating source images with urls', ->
    describe 'when successful', ->
      it 'makes the AJAX requests to add the source images', ->
        $('#load-urls').val(
          "http://url1.com/ http://url2.com/\n\nhttp://url3.com/")

        ajax_spy = spyOn($, 'ajax').and.callFake (url, params) ->
          params.success()

        $('#load-urls-button').click()

        expect(ajax_spy).toHaveBeenCalledWith '/src_images/',
          type: 'post',
          contentType: 'application/json',
          dataType: 'json',
          data: '{"url":"http://url1.com/"}',
          success: jasmine.any(Function),
          error: jasmine.any(Function)

        expect(ajax_spy).toHaveBeenCalledWith '/src_images/',
          type: 'post',
          contentType: 'application/json',
          dataType: 'json',
          data: '{"url":"http://url2.com/"}',
          success: jasmine.any(Function),
          error: jasmine.any(Function)

        expect(ajax_spy).toHaveBeenCalledWith '/src_images/',
          type: 'post',
          contentType: 'application/json',
          dataType: 'json',
          data: '{"url":"http://url3.com/"}',
          success: jasmine.any(Function),
          error: jasmine.any(Function)

      it 'displays a message to the user', ->
        $('#load-urls').val 'http://url1.com/'

        ajax_spy = spyOn($, 'ajax').and.callFake (url, params) ->
          params.success()

        $('#load-urls-button').click()

        expect($('#load-urls-message').text()).toMatch(
          /Loaded 1 source image URLs\. View them at your images\./)

      it 'clears the text area', ->
        $('#load-urls').val 'http://url1.com/'

        ajax_spy = spyOn($, 'ajax').and.callFake (url, params) ->
          params.success()

        $('#load-urls-button').click()

        expect($('#load-urls').val()).toEqual ''

      xit 'redirects to the source image index'

    describe 'when there is an error', ->
      xit 'displays an error message to the user'
      xit 'does not makes the AJAX requests to add the source images'
      xit 'clears the text area'
