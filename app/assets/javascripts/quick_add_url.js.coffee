@quick_add_url = (url, callbacks) ->
  return if url == ''
  callbacks.before_submit()

  $.ajax '/src_images/',
    type: 'post'
    contentType: 'application/json'
    dataType: 'json'
    data: JSON.stringify(
      src_image:
        url: url
    )
    success: (data) ->
      callbacks.submit_success()
      count = 0
      timer = setInterval ->
        callbacks.tick()
        $.get "/api/v3/pending_src_images/#{data.id}", (pending_data) ->
          unless pending_data.in_progress
            clearInterval(timer)
            if pending_data.error
              callbacks.error_resp(pending_data.error)
            else
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
      terminal_log = new TerminalLog $('#quick-add-url-status')
      url = input_element.val()
      quick_add_url url,
        before_submit: ->
          $('#quick-add-modal').modal()
          terminal_log.info("Submitting URL #{url}")
        submit_success: ->
          terminal_log.info('URL successfully submitted')
          input_element.val('')
        tick: ->
          terminal_log.info('Waiting for image to be loaded')
        success: (src_image_id) ->
          win.location.replace("/gend_images/new?src=#{src_image_id}")
        timed_out: ->
          terminal_log.error('Error loading URL')
        submit_error: ->
          terminal_log.error('Error submitting URL')
        error_resp: (error) ->
          terminal_log.error(error)

$(document).ready ->
  $('#quick-add-url').tooltip()
  quick_add_url_init(window)
