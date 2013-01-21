describe 'thumb_selector', ->
  beforeEach ->
    loadFixtures 'thumb_selector.html'
    window.thumb_selector_init()

  describe 'inidividual selection', ->
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

  xit 'disables disable-none-selected when none are selected'

  xit 'enables enable-some-selected when some are selected'
