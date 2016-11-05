get_thumb_index = (target) ->
  target.parents '.thumb-index'

select_all = (event) ->
  target = $(event.target)
  thumb_index = get_thumb_index(target)
  thumb_index.find('input:checkbox.selector:not(:checked)').prop(
    'checked', true).trigger('change')

select_none = (event) ->
  target = $(event.target)
  thumb_index = get_thumb_index(target)
  thumb_index.find('input:checkbox.selector:checked').prop(
    'checked', false).trigger('change')

selected_count = (parent) ->
  parent.find('input:checkbox.selector:checked').length

add_to_set = (event) ->
  set_name = $('#add-to-set-name').val()

  unless set_name is ''
    target = $(event.target)
    thumb_index = get_thumb_index(target)
    ids = thumb_index.find('input:checkbox.selector:checked').map(
      -> this.getAttribute('data-id')).get()

    $.ajax "/src_sets/#{set_name}",
      type: 'put'
      contentType: 'application/json'
      dataType: 'json'
      data: JSON.stringify(add_src_images: ids)
      success: ->
        $(window).attr('location', "/src_sets/#{set_name}")
      error: (xhr, text_status)->
        if xhr.status == 403
          message = "You do not own the set #{set_name}"
        else
          message = text_status

        add_alert thumb_index, message

remove_from_set = (event) ->
  target = $(event.target)
  thumb_index = get_thumb_index(target)
  checked = thumb_index.find('input:checkbox.selector:checked')
  ids = checked.map(-> this.getAttribute('data-id')).get()

  $.ajax '',
    type: 'put'
    contentType: 'application/json'
    dataType: 'json'
    data: JSON.stringify(delete_src_images: ids)
    success: ->
      checked.prop('checked', false).trigger('change').parents(
        '.thumbnail').remove()
    error: (xhr, text_status)->
      if xhr.status == 403
        message = 'You do not own this set'
      else
        message = text_status

      add_alert thumb_index, message

delete_thumb = (url) ->
  (event) ->
    target = $(event.target)
    thumb_index = get_thumb_index(target)
    delete_thumbs = thumb_index.find('input:checkbox.selector:checked')

    if confirm "Delete #{delete_thumbs.length} images?"
      delete_thumbs.each (_, e) ->
        id = e.getAttribute('data-id')
        $.ajax "#{url}#{id}",
          type: 'delete'
          success: ->
            $(e).prop('checked', false).trigger('change').parents(
              '.thumbnail').remove()
          error: (xhr, text_status)->
            add_alert thumb_index, "Error deleting #{id}"

delete_gend = delete_thumb '/gend_images/'

delete_src = delete_thumb '/src_images/'

update_selected = (container) ->
  selected_ct = selected_count container

  if selected_ct > 0
    container.find('.enable-some-selected').prop(
      'disabled', false).removeClass('disabled')
  else
    container.find('.disable-none-selected').prop(
      'disabled', true).addClass('disabled')

  container.find('.selected-count').text selected_ct

@thumb_selector_init = ->
  $('input:checkbox.selector').change (event) ->
    target = $(event.target)
    div = target.parents 'div.thumbnail'
    div.toggleClass 'selected', target.is(':checked')

    update_selected get_thumb_index(target)

  $('.thumb-index').each (_, e) ->
    update_selected $(e)

  $('div.thumbnail').click (event) ->
    checkbox = $(event.target).find('input:checkbox.selector').first()
    checkbox.prop('checked', !checkbox.is(':checked')).trigger('change')

  $('.select-all').click select_all

  $('.select-none').click select_none

  $('.add-to-set').click add_to_set

  $('.remove-from-set').click remove_from_set

  $('#add-to-set-name').keypress (event) ->
    add_to_set(event) if event.keyCode == 13

  $('.delete-src').click delete_src

  $('.delete-gend').click delete_gend

$(document).ready ->
  thumb_selector_init()
