class FakeWindow
  constructor: (@location) ->

class FakeLocation
  replace: (new_location) ->

describe 'gend_images', ->
  fake_log =
    info: ->
    error: ->
  fake_modal =
    modal: ->
  fake_location = new FakeLocation
  fake_window = new FakeWindow(fake_location)

  beforeEach ->
    loadFixtures 'gend_images.html'

    gend_images_init(fake_window, fake_log, fake_modal)

  describe 'creating gend images using the API with the click of a button', ->
    it 'shows the modal', ->
      modal_spy = spyOn(fake_modal, 'modal')
      $('#create-meme-button').click()
      expect(fake_modal.modal).toHaveBeenCalled()

    it 'logs the submitting message', ->
      log_spy = spyOn(fake_log, 'info')
      $('#create-meme-button').click()
      expect(fake_log.info).toHaveBeenCalledWith('Submitting request')

    describe 'when the image is not private', ->
      it 'makes the AJAX request to create the gend image', ->
        ajax_spy = spyOn($, 'ajax')

        $('#create-meme-button').click()

        expect(ajax_spy).toHaveBeenCalledWith '/api/v3/gend_images/',
          type: 'post',
          contentType: 'application/json',
          dataType: 'json',
          data: '{"src_image_id":"abcdef","captions_attributes":[{"text":' +
            '"caption 0","top_left_x_pct":0.1,"top_left_y_pct":0.2,' +
            '"width_pct":0.3,"height_pct":0.4},{"text":"caption 1",' +
            '"top_left_x_pct":0.5,"top_left_y_pct":0.6,"width_pct":0.7,' +
            '"height_pct":0.8},{"text":"caption 2","top_left_x_pct":0.9,' +
            '"top_left_y_pct":0.11,"width_pct":0.12,"height_pct":0.13}],' +
            '"private":false}',
          success: jasmine.any(Function),
          error: jasmine.any(Function)

    describe 'when the image is private', ->
      beforeEach ->
        $('#gend_image_private').click()

      it 'makes the AJAX request to create the gend image', ->
        ajax_spy = spyOn($, 'ajax')

        $('#create-meme-button').click()

        expect(ajax_spy).toHaveBeenCalledWith '/api/v3/gend_images/',
          type: 'post',
          contentType: 'application/json',
          dataType: 'json',
          data: '{"src_image_id":"abcdef","captions_attributes":[{"text":' +
            '"caption 0","top_left_x_pct":0.1,"top_left_y_pct":0.2,' +
            '"width_pct":0.3,"height_pct":0.4},{"text":"caption 1",' +
            '"top_left_x_pct":0.5,"top_left_y_pct":0.6,"width_pct":0.7,' +
            '"height_pct":0.8},{"text":"caption 2","top_left_x_pct":0.9,' +
            '"top_left_y_pct":0.11,"width_pct":0.12,"height_pct":0.13}],' +
            '"private":true}',
          success: jasmine.any(Function),
          error: jasmine.any(Function)
    describe 'when the API returns success', ->
      beforeEach ->
        jasmine.clock().install()

      afterEach ->
        jasmine.clock().uninstall()

      beforeEach ->
        spyOn($, 'ajax').and.callFake (url, params) ->
          params.success
            id: 'gend-image-id'
            status_url: 'status-url'

      it 'informs the user that url was successfully submitted', ->
        spyOn(fake_log, 'info')
        $('#create-meme-button').click()
        expect(fake_log.info).toHaveBeenCalledWith(
          'Submitted request')

      describe 'when the image is finished within the polling window', ->
        describe 'when no error is returned', ->
          beforeEach ->
            spyOn($, 'get').and.callFake (url, success) ->
              success(in_progress: false)

          it "redirects to the new image's meme page", ->
            spyOn(fake_location, 'replace')
            $('#create-meme-button').click()
            jasmine.clock().tick(1000)
            expect(fake_location.replace).toHaveBeenCalledWith(
              '/gend_image_pages/gend-image-id')

        describe 'when an error is returned', ->
          beforeEach ->
            spyOn($, 'get').and.callFake (url, success) ->
              success(error: 'an error', in_progress: false)

          it 'shows the error to the user', ->
            spyOn(fake_log, 'error')
            $('#create-meme-button').click()
            jasmine.clock().tick(1000)
            expect(fake_log.error).toHaveBeenCalledWith('an error')

          it "does not redirect to the new image's meme page", ->
            spyOn(fake_location, 'replace')
            $('#create-meme-button').click()
            jasmine.clock().tick(1000)
            expect(fake_location.replace).not.toHaveBeenCalled()

      describe 'when the image does not finish within the polling ' +
      'window', ->
        beforeEach ->
          spyOn($, 'get').and.callFake (url, params) ->

        it 'informs the user that there was an error loading the url', ->
          spyOn(fake_log, 'error')
          $('#create-meme-button').click()
          jasmine.clock().tick(10000)
          expect(fake_log.error).toHaveBeenCalledWith(
            'Timed out creating image')

        it 'logs a message each time it checks if the image is finished', ->
          spyOn(fake_log, 'info')
          $('#create-meme-button').click()
          jasmine.clock().tick(10000)
          count = 0
          for args in fake_log.info.calls.allArgs()
            if args[0] == 'Waiting for image to be created'
              count += 1
          expect(count).toEqual(10)

    describe 'when the API returns failure', ->
      it 'informs the user that there was an error loading the url', ->
        spyOn($, 'ajax').and.callFake (url, params) ->
          params.error()
        spyOn(fake_log, 'error')
        $('#create-meme-button').click()
        expect(fake_log.error).toHaveBeenCalledWith(
          'Error submitting request')

  describe 'setting src image default captions', ->
    it 'makes the AJAX request to set the default captions', ->
      ajax_spy = spyOn($, 'ajax')

      $('.set-default-captions').click()

      expect(ajax_spy).toHaveBeenCalledWith '/api/v3/src_images/abcdef',
        type: 'put',
        contentType: 'application/json',
        dataType: 'json',
        data: '{"captions_attributes":[{"text":' +
          '"caption 0","top_left_x_pct":0.1,"top_left_y_pct":0.2,' +
          '"width_pct":0.3,"height_pct":0.4},{"text":"caption 1",' +
          '"top_left_x_pct":0.5,"top_left_y_pct":0.6,"width_pct":0.7,' +
          '"height_pct":0.8},{"text":"caption 2","top_left_x_pct":0.9,' +
          '"top_left_y_pct":0.11,"width_pct":0.12,"height_pct":0.13}]}'
