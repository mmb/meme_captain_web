split_urls = (text) ->
  (url for url in text.split(/\s+/) when url)

create_with_url = (url) ->
  $.ajax '/src_images/',
         type: 'post'
         contentType: 'application/json'
         dataType: 'json'
         data: JSON.stringify(url: url)
         success: ->
           console.log "ok #{url}"
         error: (xhr, text_status) ->
           console.log "#{text_status} #{url}"

window.load_urls_init = ->
  $('#load-urls-button').click ->
    for url in split_urls($('#load-urls').val())
      create_with_url url

$(document).ready ->
  load_urls_init()
