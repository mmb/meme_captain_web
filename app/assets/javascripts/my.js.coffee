@api_token_init = ->
  $('.api-token-button').click ->
    $.post('/api_token', (data) ->
      $('.api-token').text(data.token))

$(document).ready ->
  api_token_init()
