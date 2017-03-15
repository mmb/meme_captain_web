captions_attributes_for = (index) ->
  text: $("#gend_image_captions_attributes_#{index}_text").val()
  top_left_x_pct: parseFloat(
    $("#gend_image_captions_attributes_#{index}_top_left_x_pct").val())
  top_left_y_pct: parseFloat(
    $("#gend_image_captions_attributes_#{index}_top_left_y_pct").val())
  width_pct: parseFloat(
    $("#gend_image_captions_attributes_#{index}_width_pct").val())
  height_pct: parseFloat(
    $("#gend_image_captions_attributes_#{index}_height_pct").val())

captions_data = ->
  indices = caption_indices($('#new_gend_image'))

  src_image_id: $('#gend_image_src_image_id').val()
  captions_attributes: (captions_attributes_for(i) for i in indices)
  private: $('#gend_image_private').prop('checked')

default_captions_data = ->
  indices = caption_indices($('#new_gend_image'))

  captions_attributes: (captions_attributes_for(i) for i in indices)

@gend_images_init = (win, log, modal) ->
  $('#create-meme-button').click ->
    modal.modal()
    log.info('Submitting request')

    $.ajax '/api/v3/gend_images/',
      type: 'post'
      contentType: 'application/json'
      dataType: 'json'
      data:
        JSON.stringify(captions_data())
      success: (data) ->
        log.info('Submitted request')
        count = 0
        timer = setInterval ->
          log.info('Waiting for image to be created')
          $.get data.status_url, (pending_data) ->
            unless pending_data.in_progress
              clearInterval(timer)
              if pending_data.error
                log.error(pending_data.error)
              else
                win.location.replace("/gend_image_pages/#{data.id}")
          count += 1
          if count >= 30
            clearInterval(timer)
            log.error('Timed out creating image')
        , 1000
      error: (xhr, text_status) ->
        log.error('Error submitting request')

  $('.set-default-captions').click ->
    src_image_id = $('#gend_image_src_image_id').val()
    url = "/api/v3/src_images/#{src_image_id}"
    $.ajax url,
      type: 'put'
      contentType: 'application/json'
      dataType: 'json'
      data:
        JSON.stringify(default_captions_data())

$(document).ready ->
  log = new TerminalLog $('#terminal-status')
  modal = $('#terminal-modal')
  gend_images_init(window, log, modal)
