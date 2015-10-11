class @TerminalLog

  constructor: (@element) ->
    @element.empty()

  info: (message) ->
    @append(date_span(), ' ', span_wrap('terminal-info', message), '<br />')

  error: (message) ->
    @append(date_span(), ' ', span_wrap('terminal-error', message), '<br />')

  append: (children...) ->
    @element.append(child) for child in children

date_span = ->
  span_wrap('terminal-date', date_string())

date_string = ->
  now = new Date()
  [
    leading_zero_pad(now.getHours(), 2)
    ':'
    leading_zero_pad(now.getMinutes(), 2)
    ':'
    leading_zero_pad(now.getSeconds(), 2)
    '.'
    leading_zero_pad(now.getMilliseconds(), 3)
  ].join ''

leading_zero_pad = (n, digits) ->
  s = n.toString()

  zeroes = ('0' for x in [0...Math.max(0, digits - s.length)]).join('')

  "#{zeroes}#{s}"

span_wrap = (klass, text) ->
  $('<span />').addClass(klass).text(text)
