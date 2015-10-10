quick_add_url = (url, callbacks) ->
  return if url == ''
  callbacks.before_submit()

  $.ajax '/src_images/',
    type: 'post'
    contentType: 'application/json'
    dataType: 'json'
    data: JSON.stringify(url: url)
    success: (data) ->
      callbacks.submit_success()
      count = 0
      timer = setInterval ->
        callbacks.tick()
        $.ajax "/src_images/#{data.id}",
          type: 'head',
          success: ->
            clearInterval(timer)
            callbacks.success(data.id)
        count += 1
        if count >= 10
          clearInterval(timer)
          callbacks.timed_out()
      , 1000
    error: callbacks.submit_error

window.quick_add_url_init = (win) ->
  input_element = $('#quick-add-url')

  input_element.keypress (e) ->
    if e.which == 13
      status_element = $('#quick-add-url-status')
      quick_add_url input_element.val(),
        before_submit: ->
          status_element.text('Submitting URL')
        submit_success: ->
          status_element.text('Submitted URL')
        tick: ->
          status_element.append('.')
        success: (src_image_id) ->
          win.location.replace("/gend_images/new?src=#{src_image_id}")
        timed_out: ->
          status_element.text('Error loading URL')
        submit_error: ->
          status_element.text('Error submitting URL')

$(document).ready ->
  quick_add_url_init(window)
