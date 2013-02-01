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

close_button = ->
  $('<button />').addClass('close').attr('data-dismiss', 'alert').append('&times;')

add_alert = (container, message) ->
  container.prepend($('<div />').addClass('alert alert-error').append(
    close_button).append(message))

add_to_set = (event) ->
  set_name = $('#add-to-set-name').val()

  unless set_name is ''
    target = $(event.target)
    thumb_index = get_thumb_index(target)
    ids = thumb_index.find('input:checkbox.selector:checked').map(-> this.getAttribute('data-id')).get()

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

delete_gend = (event)->
  target = $(event.target)
  thumb_index = get_thumb_index(target)
  delete_thumbs = thumb_index.find('input:checkbox.selector:checked')

  delete_thumbs.each (_, e) ->
    id = e.getAttribute('data-id')
    $.ajax "/gend_images/#{id}",
      type: 'delete'
      success: =>
        $(e).prop('checked', false).trigger('change').parents('.thumbnail').remove()
      error: (xhr, text_status)->
        add_alert thumb_index, "Error deleting #{id}"

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

  $('#add-to-set-name').keypress (event) ->
    add_to_set(event) if event.keyCode == 13

  $('.delete-gend').click delete_gend

$(document).ready ->
  thumb_selector_init()
