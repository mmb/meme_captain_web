window.close_button = ->
  $('<button />').addClass('close').attr('data-dismiss', 'alert').append('&times;')

window.add_alert = (container, message, klass = 'alert-error') ->
  container.prepend($('<div />').addClass("alert #{klass}").append(
    close_button).append(message))
