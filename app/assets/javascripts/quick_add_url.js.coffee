$(document).ready ->
  input = $('#quick-add-url')
  status = $('#quick-add-url-status')

  quick_add_url = ->
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
          status.append('.')
          $.ajax "/src_images/#{data.id}",
            type: 'head',
            success: ->
              clearInterval(timer)
              window.location.replace("/gend_images/new?src=#{data.id}")
          count += 1
          if count >= 10
            clearInterval(timer)
            status.text('Error loading URL')
        , 1000
      error: ->
        status.text('Error submitting URL')

  input.keypress (e) ->
    if e.which == 13
      quick_add_url()
