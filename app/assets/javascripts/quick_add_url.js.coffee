window.quick_add_url_init = (win) ->
  input_element = $('#quick-add-url')
  status_element = $('#quick-add-url-status')

  quick_add_url = ->
    url = input_element.val()
    return if url == ''
    status_element.text('Submitting URL')

    $.ajax '/src_images/',
      type: 'post'
      contentType: 'application/json'
      dataType: 'json'
      data: JSON.stringify(url: url)
      success: (data) ->
        status_element.text('Submitted URL')
        count = 0
        timer = setInterval ->
          status_element.append('.')
          $.ajax "/src_images/#{data.id}",
            type: 'head',
            success: ->
              clearInterval(timer)
              win.location.replace("/gend_images/new?src=#{data.id}")
          count += 1
          if count >= 10
            clearInterval(timer)
            status_element.text('Error loading URL')
        , 1000
      error: ->
        status_element.text('Error submitting URL')

  input_element.keypress (e) ->
    if e.which == 13
      quick_add_url()

$(document).ready ->
  quick_add_url_init(window)
