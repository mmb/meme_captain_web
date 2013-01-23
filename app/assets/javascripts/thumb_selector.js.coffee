get_thumb_index = (target) ->
  target.parents '.thumb-index'

select_all = (event) ->
  target = $(event.target)
  thumb_index = get_thumb_index(target)
  thumb_index.find('input:checkbox.selector:not(:checked)').prop('checked', true).trigger('change')

select_none = (event) ->
  target = $(event.target)
  thumb_index = get_thumb_index(target)
  thumb_index.find('input:checkbox.selector:checked').prop('checked', false).trigger('change')

selected_count = (parent) ->
  parent.find('input:checkbox.selector:checked').length

add_to_set = (event) ->
  target = $(event.target)
  thumb_index = get_thumb_index(target)
  ids = thumb_index.find('input:checkbox.selector:checked').map(-> this.getAttribute('data-id')).get()
  set_name = $('#add-to-set-name').val()
  $.ajax '/src_sets/' + set_name,
    type: 'put',
    data:
      add_src_images: ids
    success: ->
      console.log('success')

window.thumb_selector_init = ->
  $('input:checkbox.selector').change (event) ->
    target = $(event.target)
    div = target.parents 'div.thumbnail'
    div.toggleClass 'selected', target.is(':checked')

    thumb_index = get_thumb_index(target)
    selected_ct = selected_count thumb_index

    if selected_ct > 0
      thumb_index.find('.enable-some-selected').removeClass('disabled')
    else
      thumb_index.find('.disable-none-selected').addClass('disabled')

    thumb_index.find('.selected-count').text selected_ct

  $('div.thumbnail').click (event) ->
    checkbox = $(event.target).find('input:checkbox.selector').first()
    checkbox.prop('checked', !checkbox.is(':checked')).trigger('change')

  $('.select-all').click select_all

  $('.select-none').click select_none

  $('.add-to-set').click add_to_set

$(document).ready ->
  thumb_selector_init()
