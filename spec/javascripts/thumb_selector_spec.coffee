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

  describe 'adding to source image set', ->
    it 'makes the AJAX call to add selected images to the set', ->
      $('#div1').click()
      $('#div3').click()

      spyOn($, 'ajax')

      $('.add-to-set').click()

      expect($.ajax).toHaveBeenCalledWith(
        '/src_sets/set1',
        type: 'put',
        data:
          add_src_images: ['1', '3'],
        success: jasmine.any(Function))

