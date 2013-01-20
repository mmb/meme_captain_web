describe 'thumb_selector', ->
  beforeEach ->
    loadFixtures 'thumb_selector.html'
    window.thumb_selector_init()

  it 'gives its parents the selected class when checked', ->
    $('#check1').prop('checked', true).trigger('change')

    expect($('#div1')).toHaveClass('selected')

  it 'toggles the checkbox when the parent div is clicked', ->
    $('#div1').click()

    expect($('#check1')).toBeChecked()
