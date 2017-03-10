class TextPositioner

  bind_div: (div) ->
    @div = $(div)
    @set_img_attrs()

    @canvas_id = 'position-canvas'

    @dom_canvas = @create_dom_canvas()

    @div.empty().append(@dom_canvas)

    @fabric_canvas = @create_fabric_canvas()

    @set_fabric_canvas_size()

    @fabric_canvas.renderAll()

  add_rect: (name, x_input, y_input, width_input, height_input) ->
    rect = new fabric.Rect
      width: @scale_width(width_input.val())
      height: @scale_height(height_input.val())
      fill: '#808080'
      opacity: 0.9

    rect.setGradient 'fill',
      type: 'linear'
      x1: 0
      y1: 0
      x2: rect.getWidth()
      y2: rect.getHeight()
      colorStops:
        0: 'black'
        1: 'white'

    text = new fabric.Text "#{name + 1}",
      left: rect.getWidth() / 2
      top: rect.getHeight() / 2
      originX: 'center'
      originY: 'center'

    group = new fabric.Group [rect, text],
      name: name
      top: @scale_height(y_input.val())
      left: @scale_width(x_input.val())
      width: @scale_width(width_input.val())
      height: @scale_height(height_input.val())
      cornerSize: 20
      transparentCorners: false
      lockRotation: true
      hasRotatingPoint: false

    group.setShadow
      color: 'rgba(0,0,0,0.3)'
      blur: 10
      offsetX: 10
      offsetY: 10

    @fabric_canvas.add group

  remove_rect: (name) ->
    toRemove = (
      obj for obj in @fabric_canvas.getObjects() when obj.name is name)

    for obj in toRemove
      @fabric_canvas.remove(obj)

  set_img_attrs: ->
    @img_url = @div.attr('data-img-url')
    @img_width = @div.attr('data-img-width')
    @img_height = @div.attr('data-img-height')

  create_dom_canvas: ->
    $('<canvas />').attr('id', @canvas_id)

  create_fabric_canvas: ->
    canvas = new fabric.Canvas @canvas_id

    canvas.observe 'object:moving', @object_moving
    canvas.observe 'object:scaling', @object_scaling
    canvas.observe 'object:modified', @object_modified

    canvas

  set_fabric_canvas_size: ->
    desired_width = Math.min(@img_width, @div.width())
    desired_height = @img_height * (desired_width / @img_width)

    x_scale = desired_width / @fabric_canvas.getWidth()
    y_scale = desired_height / @fabric_canvas.getHeight()

    @fabric_canvas.setWidth(@fabric_canvas.getWidth() * x_scale)
    @fabric_canvas.setHeight(@fabric_canvas.getHeight() * y_scale)

    @fabric_canvas.setBackgroundImage(@img_url,
      @fabric_canvas.renderAll.bind(@fabric_canvas),
      width: @fabric_canvas.getWidth(),
      height: @fabric_canvas.getHeight(),
    )

    for obj in @fabric_canvas.getObjects()
      obj.set
        left: obj.getLeft() * x_scale,
        top: obj.getTop() * y_scale,
        scaleX: obj.scaleX * x_scale,
        scaleY: obj.scaleY * y_scale

      obj.setCoords()

    @fabric_canvas.renderAll()

  scale_width: (width_pct) ->
    @fabric_canvas.width * width_pct

  scale_height: (width_pct) ->
    @fabric_canvas.height * width_pct

  object_moving: (o) ->
    target = new Target(o)

    target.bound_top()
    target.bound_right()
    target.bound_bottom()
    target.bound_left()

  object_scaling: (o) ->
    target = new Target(o)

    target.bound_scale_x()
    target.bound_scale_y()

    target.fire 'object:moving'

    target.preserve_item_scale(1)

  object_modified: (o) ->
    target = new Target(o)

    $("#gend_image_captions_attributes_#{target.name()}_top_left_x_pct").val(
      target.left_pct())
    $("#gend_image_captions_attributes_#{target.name()}_top_left_y_pct").val(
      target.top_pct())
    $("#gend_image_captions_attributes_#{target.name()}_width_pct").val(
      target.width_pct())
    $("#gend_image_captions_attributes_#{target.name()}_height_pct").val(
      target.height_pct())

class @Target

  constructor: (o) ->
    @target = o.target
    @canvas = @target.canvas

  bound_top: ->
    if @target.getTop() < 0
      @target.setTop(0)

  bound_right: ->
    if @right_side() > @canvas.getWidth()
      @target.setLeft(@canvas.getWidth() - @target.getWidth())

  bound_bottom: ->
    if @bottom_side() > @canvas.getHeight()
      @target.setTop(@canvas.getHeight() - @target.getHeight())

  bound_left: ->
    if @target.getLeft() < 0
      @target.setLeft(0)

  bound_scale_x: ->
    if @right_side() > @canvas.getWidth()
      @target.setScaleX(
        (@target.getScaleX() / @target.getWidth()) *
        (@canvas.getWidth() - @target.getLeft()))
    else if @target.getLeft() < 0
      @target.setScaleX(
        (@target.getScaleX() / @target.getWidth()) * @right_side())
      @target.setLeft(0)

  bound_scale_y: ->
    if @bottom_side() > @canvas.getHeight()
      @target.setScaleY(
        (@target.getScaleY() / @target.getHeight()) *
        (@canvas.getHeight() - @target.getTop()))
    else if @target.getTop() < 0
      @target.setScaleY(
        (@target.getScaleY() / @target.getHeight()) * @bottom_side())
      @target.setTop(0)

  fire: (event) ->
    @canvas.fire event, target: @target

  name: ->
    @target.name

  left_pct: ->
    @target.getLeft() / @canvas.getWidth()

  top_pct: ->
    @target.getTop() / @canvas.getHeight()

  width_pct: ->
    @target.getWidth() / @canvas.getWidth()

  height_pct: ->
    @target.getHeight() / @canvas.getHeight()

  right_side: ->
    @target.getLeft() + @target.getWidth()

  bottom_side: ->
    @target.getTop() + @target.getHeight()

  preserve_item_scale: (index) ->
    text = @target.item(index)
    text.setScaleX(1 / @target.getScaleX())
    text.setScaleY(1 / @target.getScaleY())
    @target.dirty = true

@text_positioner_init = ->
  $('.text-positioner').each (index, element) ->
    tp = new TextPositioner
    tp.bind_div element

    num_captions = $('.caption-label').size()

    for index in [0...num_captions]
      tp.add_rect index,
        $("#gend_image_captions_attributes_#{index}_top_left_x_pct"),
        $("#gend_image_captions_attributes_#{index}_top_left_y_pct"),
        $("#gend_image_captions_attributes_#{index}_width_pct"),
        $("#gend_image_captions_attributes_#{index}_height_pct")

    $(element).data 'tp', tp

    $(window).resize ->
      tp.set_fabric_canvas_size()

$(document).ready ->
  text_positioner_init()
