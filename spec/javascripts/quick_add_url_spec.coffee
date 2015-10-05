class FakeWindow
  constructor: (@location) ->

class FakeLocation
  replace: (new_location) ->

submit_url = ->
  e = $.Event('keypress')
  e.which = 13
  $('#quick-add-url').trigger(e)

describe 'quick_add_url', ->
  fake_location = null

  beforeEach ->
    loadFixtures 'quick_add_url.html'
    fake_location = new FakeLocation
    fake_window = new FakeWindow(fake_location)
    window.quick_add_url_init(fake_window)

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

        submit_url()
        expect($('#quick-add-url-status').text()).toBe('Submitting URL')

      describe 'when the API returns success', ->
        beforeEach ->
          jasmine.clock().install()

        afterEach ->
          jasmine.clock().uninstall()

        it 'informs the user that url was successfully submitted', ->
          spyOn($, 'ajax').and.callFake (url, params) ->
            params.success
              status_url: 'pending src image url'
          submit_url()
          expect($('#quick-add-url-status').text()).toBe('Submitted URL')

        describe 'when the image is finished within the polling window', ->
          beforeEach ->
            fake_xhr =
              getResponseHeader: -> 'image/jpeg'
            spyOn($, 'ajax').and.callFake (url, params) ->
              switch url
                when '/src_images/'
                  params.success
                    id: 'src_image_id'
                    status_url: 'pending src image url'
                when 'pending src image url'
                  params.success {}, null, fake_xhr

          it "redirects to the new image's meme creation page", ->
            spyOn(fake_location, 'replace')
            submit_url()
            jasmine.clock().tick(1000)
            expect(fake_location.replace).toHaveBeenCalledWith(
              '/gend_images/new?src=src_image_id')

        describe 'when the polling returns an error', ->
          beforeEach ->
            spyOn($, 'ajax').and.callFake (url, params) ->
              switch url
                when '/src_images/'
                  params.success
                    id: 'src_image_id'
                    status_url: 'pending src image url'
                when 'pending src image url'
                  params.success error: 'error'

          it 'informs the user that there was an error loading the url', ->
            spyOn(fake_location, 'replace')
            submit_url()
            jasmine.clock().tick(1000)
            expect($('#quick-add-url-status').text()).toBe('Error loading URL')

        describe 'when the image does not finish within the polling window', ->
          beforeEach ->
            fake_xhr =
              getResponseHeader: -> 'application/json'
            spyOn($, 'ajax').and.callFake (url, params) ->
              switch url
                when '/src_images/'
                  params.success
                    id: 'src_image_id'
                    status_url: 'pending src image url'
                when 'pending src image url'
                  params.success {}, null, fake_xhr

          it 'informs the user that there was an error loading the url', ->
            submit_url()
            jasmine.clock().tick(30000)
            expect($('#quick-add-url-status').text()).toBe('Error loading URL')

      describe 'when the API returns failure', ->
        it 'informs the user that there was an error loading the url', ->
          spyOn($, 'ajax').and.callFake (url, params) ->
            params.error()
          submit_url()
          expect($('#quick-add-url-status').text()).toBe('Error submitting URL')
