class FakeWindow
  constructor: (@location) ->

class FakeLocation
  replace: (new_location) ->

submit_url = ->
  e = $.Event('keypress', which: 13)
  $('#quick-add-url').trigger(e)

describe 'quick_add_url', ->
  fake_location = null
  fake_log =
    info: ->
    error: ->

  beforeEach ->
    loadFixtures 'quick_add_url.html'
    fake_location = new FakeLocation
    fake_window = new FakeWindow(fake_location)
    window.quick_add_url_init(fake_window, fake_log)

  describe 'loading an image from a url', ->
    describe 'when the url is empty', ->
      beforeEach ->
        $('#quick-add-url').val('')

      it 'does not submit an AJAX request', ->
        ajax_spy = spyOn($, 'ajax')

        submit_url()
        expect(ajax_spy).not.toHaveBeenCalled()

    describe 'when the url is not empty', ->
      beforeEach ->
        $('#quick-add-url').val('http://images.com/image.jpg')

      it 'informs the user that the URL is being submitted', ->
        ajax_spy = spyOn($, 'ajax')
        spyOn(fake_log, 'info')

        submit_url()
        expect(fake_log.info).toHaveBeenCalledWith(
          'Submitting URL http://images.com/image.jpg')

      describe 'when the API returns success', ->
        beforeEach ->
          jasmine.clock().install()

        afterEach ->
          jasmine.clock().uninstall()

        it 'informs the user that url was successfully submitted', ->
          spyOn($, 'ajax').and.callFake (url, params) ->
            params.success()
          spyOn(fake_log, 'info')
          submit_url()
          expect(fake_log.info).toHaveBeenCalledWith(
            'URL successfully submitted')

        describe 'when the image is finished within the polling window', ->
          beforeEach ->
            spyOn($, 'ajax').and.callFake (url, params) ->
              params.success(id: 'src_image_id')

          describe 'when no error is returned', ->
            beforeEach ->
              spyOn($, 'get').and.callFake (url, success) ->
                success(in_progress: false)

            it "redirects to the new image's meme creation page", ->
              spyOn(fake_location, 'replace')
              submit_url()
              jasmine.clock().tick(1000)
              expect(fake_location.replace).toHaveBeenCalledWith(
                '/gend_images/new?src=src_image_id')

          describe 'when an error is returned', ->
            beforeEach ->
              spyOn($, 'get').and.callFake (url, success) ->
                success(error: 'an error', in_progress: false)

            it 'shows the error to the user', ->
              spyOn(fake_log, 'error')
              submit_url()
              jasmine.clock().tick(1000)
              expect(fake_log.error).toHaveBeenCalledWith('an error')

            it "does not redirect to the new image's meme creation page", ->
              spyOn(fake_location, 'replace')
              submit_url()
              jasmine.clock().tick(1000)
              expect(fake_location.replace).not.toHaveBeenCalled()

        describe 'when the image does not finish within the polling window', ->
          beforeEach ->
            spyOn($, 'ajax').and.callFake (url, params) ->
              switch url
                when '/src_images/'
                  params.success
                    id: 'src_image_id'

          it 'informs the user that there was an error loading the url', ->
            spyOn(fake_log, 'error')
            submit_url()
            jasmine.clock().tick(10000)
            expect(fake_log.error).toHaveBeenCalledWith(
              'Error loading URL')

          it 'logs a message each time it checks if the image is finished', ->
            spyOn(fake_log, 'info')
            submit_url()
            jasmine.clock().tick(10000)
            count = 0
            for args in fake_log.info.calls.allArgs()
              if args[0] == 'Waiting for image to be loaded'
                count += 1
            expect(count).toEqual(10)

      describe 'when the API returns failure', ->
        it 'informs the user that there was an error loading the url', ->
          spyOn($, 'ajax').and.callFake (url, params) ->
            params.error()
          spyOn(fake_log, 'error')
          submit_url()
          expect(fake_log.error).toHaveBeenCalledWith(
            'Error submitting URL')
