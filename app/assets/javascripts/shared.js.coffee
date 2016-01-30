window.close_button = ->
  $('<button />').addClass('close').attr('data-dismiss', 'alert').append(
    '&times;')

window.add_alert = (container, message, klass = 'alert-danger') ->
  container.prepend($('<div />').addClass("alert #{klass}").append(
    close_button).append(message))

@paste_handler = (win, event, clipboard, reader) ->
  image_file = clipboard.last_if_image(event)
  return unless image_file?

  reader.onloadend = ->
    url = reader.result
    terminal_log = new TerminalLog $('#quick-add-url-status')
    quick_add_url url,
      before_submit: ->
        $('#quick-add-modal').modal()
        terminal_log.info("Submitting image data #{url[0..31]}...")
      submit_success: ->
        terminal_log.info('Image data successfully submitted')
      tick: ->
        terminal_log.info('Waiting for image to be processed')
      success: (src_image_id) ->
        win.location.replace("/gend_images/new?src=#{src_image_id}")
      timed_out: ->
        terminal_log.error('Error loading image data')
      submit_error: ->
        terminal_log.error('Error submitting image data')
      error_resp: (error) ->
        terminal_log.error(error)

  reader.readAsDataURL(image_file)

window.addEventListener 'paste', (event) ->
  clipboard = new Clipboard
  reader = new FileReader

  paste_handler window, event, clipboard, reader
