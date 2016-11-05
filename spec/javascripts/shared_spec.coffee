class FakeWindow
  constructor: (@location) ->

class FakeLocation
  replace: (new_location) ->

describe 'shared', ->
  describe 'paste_handler', ->
    fake_location = new FakeLocation
    fake_window = new FakeWindow(fake_location)
    fake_clipboard = {}
    fake_event = {}
    fake_reader =
      readAsDataURL: (image_file) ->
    fake_log =
      info: ->
      error: ->
    fake_modal =
      modal: ->

    describe 'loading an image from the clipboard', ->
      describe 'when the clipboard does not have an image', ->
        beforeEach ->
          fake_clipboard.last_if_image = (event) ->

        it 'does not submit an AJAX request', ->
          ajax_spy = spyOn($, 'ajax')

          paste_handler(
            fake_window, fake_event, fake_clipboard, fake_reader, fake_log,
            fake_modal)
          expect(ajax_spy).not.toHaveBeenCalled()

      describe 'when the clipboard has an image', ->
        fake_image_file = {}

        beforeEach ->
          fake_clipboard.last_if_image = (event) ->
            fake_image_file
          fake_reader.result = 'fake reader result'
          fake_reader.readAsDataURL = (image_file) ->
            fake_reader.onloadend()

        it 'calls the reader with the image', ->
          read_as_data_url_spy = spyOn(fake_reader, 'readAsDataURL')
          paste_handler(fake_window, fake_event, fake_clipboard, fake_reader,
            fake_log, fake_modal)
          expect(read_as_data_url_spy).toHaveBeenCalledWith(fake_image_file)

        it 'informs the user that the URL is being submitted', ->
          ajax_spy = spyOn($, 'ajax')
          spyOn(fake_log, 'info')
          spyOn(fake_modal, 'modal')

          paste_handler(fake_window, fake_event, fake_clipboard, fake_reader,
            fake_log, fake_modal)
          expect(fake_modal.modal).toHaveBeenCalled()
          expect(fake_log.info).toHaveBeenCalledWith(
            'Submitting image data fake reader result...')

        describe 'when the API returns success', ->
          beforeEach ->
            jasmine.clock().install()

          afterEach ->
            jasmine.clock().uninstall()

          it 'informs the user that url was successfully submitted', ->
            spyOn($, 'ajax').and.callFake (url, params) ->
              params.success()
            spyOn(fake_log, 'info')
            paste_handler(fake_window, fake_event, fake_clipboard, fake_reader,
              fake_log, fake_modal)
            expect(fake_log.info).toHaveBeenCalledWith(
              'Image data successfully submitted')

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
                paste_handler(fake_window, fake_event, fake_clipboard,
                  fake_reader, fake_log, fake_modal)
                jasmine.clock().tick(1000)
                expect(fake_location.replace).toHaveBeenCalledWith(
                  '/gend_images/new?src=src_image_id')

            describe 'when an error is returned', ->
              beforeEach ->
                spyOn($, 'get').and.callFake (url, success) ->
                  success(error: 'an error', in_progress: false)

              it 'shows the error to the user', ->
                spyOn(fake_log, 'error')
                paste_handler(fake_window, fake_event, fake_clipboard,
                  fake_reader, fake_log, fake_modal)
                jasmine.clock().tick(1000)
                expect(fake_log.error).toHaveBeenCalledWith('an error')

              it "does not redirect to the new image's meme creation page", ->
                spyOn(fake_location, 'replace')
                paste_handler(fake_window, fake_event, fake_clipboard,
                  fake_reader, fake_log, fake_modal)
                jasmine.clock().tick(1000)
                expect(fake_location.replace).not.toHaveBeenCalled()

          describe 'when the image does not finish within the polling ' +
          'window', ->
            beforeEach ->
              spyOn($, 'ajax').and.callFake (url, params) ->
                switch url
                  when '/src_images/'
                    params.success
                      id: 'src_image_id'

            it 'informs the user that there was an error loading the url', ->
              spyOn(fake_log, 'error')
              paste_handler(
                fake_window, fake_event, fake_clipboard, fake_reader, fake_log,
                fake_modal)
              jasmine.clock().tick(10000)
              expect(fake_log.error).toHaveBeenCalledWith(
                'Error loading image data')

            it 'logs a message each time it checks if the image is finished', ->
              spyOn(fake_log, 'info')
              paste_handler(
                fake_window, fake_event, fake_clipboard, fake_reader, fake_log,
                fake_modal)
              jasmine.clock().tick(10000)
              count = 0
              for args in fake_log.info.calls.allArgs()
                if args[0] == 'Waiting for image to be processed'
                  count += 1
              expect(count).toEqual(10)

        describe 'when the API returns failure', ->
          it 'informs the user that there was an error loading the url', ->
            spyOn($, 'ajax').and.callFake (url, params) ->
              params.error()
            spyOn(fake_log, 'error')
            paste_handler(
              fake_window, fake_event, fake_clipboard, fake_reader, fake_log,
              fake_modal)
            expect(fake_log.error).toHaveBeenCalledWith(
              'Error submitting image data')
