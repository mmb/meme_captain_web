class TextPositioner

  bind_div: (div) ->
    @div = $(div)
    @set_img_attrs()

    @canvas_id = 'position-canvas'

    @dom_canvas = @create_dom_canvas()

    @div.empty().append(@dom_canvas)

    @fabric_canvas = @create_fabric_canvas()

    @fabric_canvas.renderAll()

  add_rect: (name, x_input, y_input, width_input, height_input) ->
    rect = new fabric.Rect
      name: name
      top: @scale_height(y_input.val()) + @scale_height(height_input.val()) / 2.0
      left: @scale_width(x_input.val()) + @scale_width(width_input.val()) / 2.0
      width: @scale_width(width_input.val())
      height: @scale_height(height_input.val())
      fill: '#808080'
      cornersize: 20
      lockRotation: true
      hasRotatingPoint: false

    rect.setGradientFill
      x1: '0%'
      y1: '0%'
      x2: '100%'
      y2: '100%'
      colorStops:
        0: 'black'
        1: 'white'

    @fabric_canvas.add rect

  set_img_attrs: ->
    @img_url = @div.attr('data-img-url')
    @img_width = @div.attr('data-img-width')
    @img_height = @div.attr('data-img-height')

  create_dom_canvas: ->
    $('<canvas />').attr('id', @canvas_id)

  create_fabric_canvas: ->
    canvas = new fabric.Canvas @canvas_id,
      'backgroundImage': @img_url
    canvas.setWidth @img_width
    canvas.setHeight @img_height

    canvas.observe 'object:moving', @object_moving
    canvas.observe 'object:scaling', @object_scaling
    canvas.observe 'object:modified', @object_modified

    canvas

  scale_width: (width_pct) ->
    @fabric_canvas.width * width_pct

  scale_height: (width_pct) ->
    @fabric_canvas.height * width_pct

  object_moving: (o) =>
    target = new Target(o)

    target.bound_top()
    target.bound_right()
    target.bound_bottom()
    target.bound_left()

  object_scaling: (o) =>
    target = new Target(o)

    target.bound_scale_x()
    target.bound_scale_y()

    target.fire 'object:moving'

  object_modified: (o) =>
    target = new Target(o)

    $("#gend_image_captions_attributes_#{target.name()}_top_left_x_pct").val(target.left_pct())
    $("#gend_image_captions_attributes_#{target.name()}_top_left_y_pct").val(target.top_pct())
    $("#gend_image_captions_attributes_#{target.name()}_width_pct").val(target.width_pct())
    $("#gend_image_captions_attributes_#{target.name()}_height_pct").val(target.height_pct())

class @Target

  constructor: (o) ->
    @target = o.target
    @canvas = @target.canvas

  bound_top: ->
    if @top_side() < 0
      @target.setTop @half_height()

  bound_right: ->
    if @right_side() > @canvas.width
      @target.setLeft(@canvas.width - @half_width())

  bound_bottom: ->
    if @bottom_side() > @canvas.height
      @target.setTop(@canvas.height - @half_height())

  bound_left: ->
    if @left_side() < 0
      @target.setLeft @half_width()

  bound_scale_x: ->
    max = @max_scale_x()

    if @target.scaleX > max
      @target.scaleX = max

  bound_scale_y: ->
    max = @max_scale_y()

    if @target.scaleY > max
      @target.scaleY = max

  fire: (event) ->
    @canvas.fire event, target: @target

  name: ->
    @target.name

  left_pct: ->
    (@target.getLeft() - (@target.getWidth() / 2)) / @canvas.width

  top_pct: ->
    (@target.getTop() - (@target.getHeight() / 2)) / @canvas.height

  width_pct: ->
    @target.getWidth() / @canvas.width

  height_pct: ->
    @target.getHeight() / @canvas.height

  max_scale_x: ->
    @canvas.width / @target.width

  max_scale_y: ->
    @canvas.height / @target.height

  top_side: ->
    @target.getTop() - @half_height()

  right_side: ->
    @target.getLeft() + @half_width()

  bottom_side: ->
    @target.getTop() + @half_height()

  left_side: ->
    @target.getLeft() - @half_width()

  half_width: ->
    @target.getWidth() / 2

  half_height: ->
    @target.getHeight() / 2

$(document).ready ->
  $('.text-positioner').each (index, element) ->
    tp = new TextPositioner
    tp.bind_div element

    tp.add_rect '0',
      $('#gend_image_captions_attributes_0_top_left_x_pct'),
      $('#gend_image_captions_attributes_0_top_left_y_pct'),
      $('#gend_image_captions_attributes_0_width_pct'),
      $('#gend_image_captions_attributes_0_height_pct')

    tp.add_rect '1',
      $('#gend_image_captions_attributes_1_top_left_x_pct'),
      $('#gend_image_captions_attributes_1_top_left_y_pct'),
      $('#gend_image_captions_attributes_1_width_pct'),
      $('#gend_image_captions_attributes_1_height_pct')

    $(element).data 'tp', tp
