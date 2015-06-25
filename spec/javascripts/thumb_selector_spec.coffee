describe 'thumb_selector', ->
  beforeEach ->
    loadFixtures 'thumb_selector.html'
    window.thumb_selector_init()

  describe 'individual selection', ->
    it 'gives its parents the selected class when checked', ->
      $('#check1').prop('checked', true).trigger('change')

      expect($('#div1')).toHaveClass('selected')

    it 'toggles the checkbox when the parent div is clicked', ->
      $('#div1').click()

      expect($('#check1')).toBeChecked()

    it 'updates the selected count', ->
      $('#div1').click()
      $('#div2').click()
      $('#div2').click()

      expect($('.selected-count')).toHaveText('1')

  it 'selects all when a select all button is clicked', ->
    $('.select-all').click()

    expect($('#check1')).toBeChecked()
    expect($('#check2')).toBeChecked()
    expect($('#check3')).toBeChecked()

  it 'selects none when a select none button is clicked', ->
    $('.select-all').click()
    $('.select-none').click()

    expect($('#check1')).not.toBeChecked()
    expect($('#check2')).not.toBeChecked()
    expect($('#check3')).not.toBeChecked()

  it 'disables disable-none-selected when none are selected', ->
    $('#div1').click()
    $('.select-none').click()

    expect($('.disable-none-selected')).toHaveClass('disabled')

  it 'enables enable-some-selected when some are selected', ->
    $('#div1').click()
    expect($('.enable-some-selected')).not.toHaveClass('disabled')

  describe 'adding to a source image set', ->
    beforeEach ->
      $('#div1').click()
      $('#div3').click()

    describe 'when successful', ->
      it 'redirects to the set', ->
        spyOn $, 'attr'

        spyOn($, 'ajax').and.callFake (url, params) ->
          params.success()

        $('.add-to-set').click()

        expect($.attr).toHaveBeenCalledWith(jasmine.any(Object), 'location',
          '/src_sets/set1')

    describe 'when the response is forbidden', ->
      it 'shows the user an error message', ->
        spyOn($, 'ajax').and.callFake (url, params) ->
          params.error({status: 403}, '')

        $('.add-to-set').click()

        expect($('.alert')).toHaveText(/You do not own the set set1/)

    describe 'when the response is another error', ->
      it 'shows the user an error message', ->
        spyOn($, 'ajax').and.callFake (url, params) ->
          params.error({status: 500}, 'some error')

        $('.add-to-set').click()

        expect($('.alert')).toHaveText(/some error/)

  describe 'removing source images from a set', ->
    beforeEach ->
      $('#div1').click()
      $('#div3').click()

    describe 'when successful', ->
      it 'removes the images from the DOM', ->
        spyOn($, 'ajax').and.callFake (url, params) ->
          params.success()

        $('.remove-from-set').click()

        expect($('#div1').length).toBe(0)
        expect($('#div3').length).toBe(0)

    describe 'when the response is forbidden', ->
      it 'shows the user an error message', ->
        spyOn($, 'ajax').and.callFake (url, params) ->
          params.error({status: 403}, '')

        $('.remove-from-set').click()

        expect($('.alert')).toHaveText(/You do not own this set/)

    describe 'when the response is another error', ->
      it 'shows the user an error message', ->
        spyOn($, 'ajax').and.callFake (url, params) ->
          params.error({status: 500}, 'some error')

        $('.remove-from-set').click()

        expect($('.alert')).toHaveText(/some error/)

  describe 'deleting a source image', ->
    describe 'when deletion is successful', ->
      it 'removes the images from the DOM', ->
        $('#div1').click()
        $('#div3').click()

        spyOn($, 'ajax').and.callFake (url, params) ->
          params.success()
        spyOn(window, 'confirm').and.returnValue(true)

        $('.delete-src').click()

        expect($('#div1').length).toBe(0)
        expect($('#div2').length).toBe(1)
        expect($('#div1').length).toBe(0)

    describe 'when the response is an error', ->
      beforeEach ->
        $('#div1').click()

        spyOn($, 'ajax').and.callFake (url, params) ->
          params.error({status: 500}, '')
        spyOn(window, 'confirm').and.returnValue(true)

        $('.delete-src').click()

      it 'shows the user an error message', ->
        expect($('.alert')).toHaveText(/Error deleting 1/)

      it 'does not delete the image', ->
        expect($('#div1').length).toBe(1)

    describe 'when the request is not confirmed', ->

      it "doesn't delete the image", ->
        $('#div1').click()
        spyOn(window, 'confirm').and.returnValue(false)
        $('.delete-src').click()
        expect($('#div1').length).toBe(1)

  describe 'deleting a generated image', ->

    describe 'when deletion is successful', ->
      it 'removes the images from the DOM', ->
        $('#div1').click()
        $('#div3').click()

        spyOn($, 'ajax').and.callFake (url, params) ->
          params.success()
        spyOn(window, 'confirm').and.returnValue(true)

        $('.delete-gend').click()

        expect($('#div1').length).toBe(0)
        expect($('#div2').length).toBe(1)
        expect($('#div1').length).toBe(0)

    describe 'when the response is an error', ->
      beforeEach ->
        $('#div1').click()

        spyOn($, 'ajax').and.callFake (url, params) ->
          params.error({status: 500}, '')
        spyOn(window, 'confirm').and.returnValue(true)

        $('.delete-gend').click()

      it 'shows the user an error message', ->
        expect($('.alert')).toHaveText(/Error deleting 1/)

      it 'does not delete the image', ->
        expect($('#div1').length).toBe(1)

    describe 'when the request is not confirmed', ->

      it "doesn't delete the image", ->
        $('#div1').click()
        spyOn(window, 'confirm').and.returnValue(false)
        $('.delete-gend').click()
        expect($('#div1').length).toBe(1)

  describe 'enable based on selection', ->
    it 'disable-none-selected should be disabled initially', ->
      expect($('.disable-none-selected').prop('disabled')).toBe(true)

    it 'disable-none-selected should be disabled when none are selected', ->
      $('#div1').click()
      $('#div1').click()
      expect($('.disable-none-selected').prop('disabled')).toBe(true)

    it 'enable-some-selected should be enabled when some are selected', ->
      $('#div1').click()
      expect($('.enable-some-selected').prop('disabled')).toBe(false)
