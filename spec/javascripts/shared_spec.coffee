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

    beforeEach ->
      loadFixtures 'shared.html'

    describe 'loading an image from the clipboard', ->
      describe 'when the clipboard does not have an image', ->
        beforeEach ->
          fake_clipboard.last_if_image = (event) ->

        it 'does not submit an AJAX request', ->
          ajax_spy = spyOn($, 'ajax')

          paste_handler(fake_window, fake_event, fake_clipboard, fake_reader)
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
          paste_handler(fake_window, fake_event, fake_clipboard, fake_reader)
          expect(read_as_data_url_spy).toHaveBeenCalledWith(fake_image_file)

        it 'informs the user that the URL is being submitted', ->
          ajax_spy = spyOn($, 'ajax')

          paste_handler(fake_window, fake_event, fake_clipboard, fake_reader)
          expect($('#quick-add-url-status').text()).toMatch(
            'Submitting image data fake reader result')

        describe 'when the API returns success', ->
          beforeEach ->
            jasmine.clock().install()

          afterEach ->
            jasmine.clock().uninstall()

          it 'informs the user that url was successfully submitted', ->
            spyOn($, 'ajax').and.callFake (url, params) ->
              params.success()
            paste_handler(fake_window, fake_event, fake_clipboard, fake_reader)
            expect($('#quick-add-url-status').text()).toMatch(
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
                paste_handler(
                  fake_window, fake_event, fake_clipboard, fake_reader)
                jasmine.clock().tick(1000)
                expect(fake_location.replace).toHaveBeenCalledWith(
                  '/gend_images/new?src=src_image_id')

            describe 'when an error is returned', ->
              beforeEach ->
                spyOn($, 'get').and.callFake (url, success) ->
                  success(error: 'an error', in_progress: false)

              it 'shows the error to the user', ->
                paste_handler(
                  fake_window, fake_event, fake_clipboard, fake_reader)
                jasmine.clock().tick(1000)
                expect($('#quick-add-url-status').text()).toMatch('an error')

              it "does not redirect to the new image's meme creation page", ->
                spyOn(fake_location, 'replace')
                paste_handler(
                  fake_window, fake_event, fake_clipboard, fake_reader)
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
              paste_handler(
                fake_window, fake_event, fake_clipboard, fake_reader)
              jasmine.clock().tick(10000)
              expect($('#quick-add-url-status').text()).toMatch(
                'Error loading image data')

            it 'logs a message each time it checks if the image is finished', ->
              paste_handler(
                fake_window, fake_event, fake_clipboard, fake_reader)
              jasmine.clock().tick(10000)
              expect($('#quick-add-url-status').text().match(
                /Waiting for image to be processed/g).length).toEqual(10)

        describe 'when the API returns failure', ->
          it 'informs the user that there was an error loading the url', ->
            spyOn($, 'ajax').and.callFake (url, params) ->
              params.error()
            paste_handler(
              fake_window, fake_event, fake_clipboard, fake_reader)
            expect($('#quick-add-url-status').text()).toMatch(
              'Error submitting image data')
