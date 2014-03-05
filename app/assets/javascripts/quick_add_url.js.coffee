$(document).ready ->
  quick_add_url_button = $('#quick-add-url-button')
  input = $('#quick-add-url')
  status = quick_add_url_button

  quick_add_url_button.click ->
    status.text('Submitting URL')
    url = input.val()

    $.ajax '/src_images/',
      type: 'post'
      contentType: 'application/json'
      dataType: 'json'
      data: JSON.stringify(url: url)
      success: (data) ->
        status.text('Submitted URL')
        count = 0
        timer = setInterval ->
          $.ajax "/src_images/#{data.id}",
            type: 'head',
            success: ->
              clearInterval(timer)
              window.location.replace("/gend_images/new?src=#{data.id}")
            error: ->
              clearInterval(timer)
              status.text('Error loading URL')
          count += 1
          if count >= 10
            clearInterval(timer)
        , 1000
      error: ->
        status.text('Error submitting URL')

  input.keypress (e) ->
    if e.which == 13
      quick_add_url_button.click()
