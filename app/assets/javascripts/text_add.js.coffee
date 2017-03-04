@add_text_positioner = (index) ->
  text_positioner = $('.text-positioner').data('tp')

  text_positioner.add_rect index,
    $("#gend_image_captions_attributes_#{index}_top_left_x_pct"),
    $("#gend_image_captions_attributes_#{index}_top_left_y_pct"),
    $("#gend_image_captions_attributes_#{index}_width_pct"),
    $("#gend_image_captions_attributes_#{index}_height_pct")

@remove_text_positioner = (index) ->
  text_positioner = $('.text-positioner').data('tp')

  text_positioner.remove_rect(index)

@text_add_init = ->
  $('.text-add').click (event) ->
    target = $(event.target)

    form = target.closest 'form'

    indices = caption_indices(form)
    if indices.length > 0
      index = indices[indices.length - 1] + 1
    else
      index = 0

    div = $('<div />').
      attr('id', "caption-#{index}-form-group").
      addClass('form-group')
    div.append "<label
      for=\"gend_image_captions_attributes_#{index}_text\">Caption
      #{index + 1}</label>"
    div.append "<button type=\"button\" class=\"close caption-close\"
      aria-label=\"Close\" tabindex=\"-1\"><span aria-hidden=\"true\"
      data-index=\"#{index}\">&times;</span></button>"
    div.append "<textarea id=\"gend_image_captions_attributes_#{index}_text\"
      name=\"gend_image[captions_attributes][#{index}][text]\"
      class=\"form-control caption-textarea\" cols=\"40\" rows=\"2\"
      data-index=\"#{index}\" /></textarea>"
    div.append "<input id=\"gend_image_captions_attributes_#{index}_font\"
      name=\"gend_image[captions_attributes][#{index}][font]\"
      type=\"hidden\" value=\"\" />"
    div.append "<input
      id=\"gend_image_captions_attributes_#{index}_top_left_x_pct\"
      name=\"gend_image[captions_attributes][#{index}][top_left_x_pct]\"
      type=\"hidden\" value=\"0.05\" />"
    div.append "<input
      id=\"gend_image_captions_attributes_#{index}_top_left_y_pct\"
      name=\"gend_image[captions_attributes][#{index}][top_left_y_pct]\"
      type=\"hidden\" value =\"0.375\" />"
    div.append "<input
      id=\"gend_image_captions_attributes_#{index}_width_pct\"
      name=\"gend_image[captions_attributes][#{index}][width_pct]\"
      type=\"hidden\" value=\"0.9\" />"
    div.append "<input
      id=\"gend_image_captions_attributes_#{index}_height_pct\"
      name=\"gend_image[captions_attributes][#{index}][height_pct]\"
      type=\"hidden\" value=\"0.25\" />"
    target.before div

    form.find("#gend_image_captions_attributes_#{index}_text").focus()

    window.add_text_positioner index

  $('#new_gend_image').on 'click', '.caption-close', (event) ->
    target = $(event.target)
    index = target.data('index')
    $("#caption-#{index}-form-group").remove()

    window.remove_text_positioner index

$(document).ready ->
  text_add_init()
