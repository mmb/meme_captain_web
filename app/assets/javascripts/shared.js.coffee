@close_button = ->
  $('<button />').addClass('close').attr('data-dismiss', 'alert').append(
    '&times;')

@add_alert = (container, message, klass = 'alert-danger') ->
  container.prepend($('<div />').addClass("alert #{klass}").append(
    close_button).append(message))

@paste_handler = (win, event, clipboard, reader, log, modal) ->
  image_file = clipboard.last_if_image(event)
  return unless image_file?

  reader.onloadend = ->
    url = reader.result
    quick_add_url url,
      before_submit: ->
        modal.modal()
        log.info("Submitting image data #{url[0..31]}...")
      submit_success: ->
        log.info('Image data successfully submitted')
      tick: ->
        log.info('Waiting for image to be processed')
      success: (src_image_id) ->
        win.location.replace("/gend_images/new?src=#{src_image_id}")
      timed_out: ->
        log.error('Timed out loading image data')
      submit_error: ->
        log.error('Error submitting image data')
      error_resp: (error) ->
        log.error(error)

  reader.readAsDataURL(image_file)

window.addEventListener 'paste', (event) ->
  clipboard = new Clipboard
  reader = new FileReader
  log = new TerminalLog $('#terminal-status')
  modal = $('#terminal-modal')

  paste_handler window, event, clipboard, reader, log, modal
