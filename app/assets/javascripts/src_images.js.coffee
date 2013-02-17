split_urls = (text) ->
  (url for url in text.split(/\s+/) when url)

create_with_url = (url) ->
  $.ajax '/src_images/',
         type: 'post'
         contentType: 'application/json'
         dataType: 'json'
         data: JSON.stringify(url: url)
         success: ->
         error: (xhr, text_status) ->
           add_alert $('#load-urls-message'), "Error adding #{url}"

window.load_urls_init = ->
  $('#load-urls-button').click ->
    urls = split_urls($('#load-urls').val())
    $.when((create_with_url url for url in urls)...).then ->
      add_alert $('#load-urls-message'), "Loaded #{urls.length} source image URLs.", 'alert-info'

      $('#load-urls').val ''

$(document).ready ->
  load_urls_init()
