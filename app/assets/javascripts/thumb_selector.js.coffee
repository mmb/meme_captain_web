window.thumb_selector_init = ->
  $('input:checkbox.selector').change (event) ->
    div = $(event.target).parents 'div.thumbnail'
    div.toggleClass 'selected', $(event.target).is(':checked')

  $('div.thumbnail').click (event) ->
    checkbox = $(event.target).find('input:checkbox.selector').first()
    checkbox.prop('checked', !checkbox.is(':checked')).trigger('change')

$(document).ready ->
  thumb_selector_init()
