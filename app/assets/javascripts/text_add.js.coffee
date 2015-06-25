count_caption_fields = (form) ->
  form.find('textarea').filter(->
    $(this).attr('id')?.match /gend_image_captions_attributes_\d_text/).size()

window.add_text_positioner = (index) ->
  text_positioner = $('.text-positioner').data('tp')

  text_positioner.add_rect index,
    $("#gend_image_captions_attributes_#{index}_top_left_x_pct"),
    $("#gend_image_captions_attributes_#{index}_top_left_y_pct"),
    $("#gend_image_captions_attributes_#{index}_width_pct"),
    $("#gend_image_captions_attributes_#{index}_height_pct")

@text_add_init = ->
  $('.text-add').click (event) ->
    target = $(event.target)

    form = target.closest 'form'

    index = count_caption_fields(form)

    div = $('<div />').addClass('form-group')
    div.append "<label
      for=\"gend_image_captions_attributes_#{index}_text\">Caption
      #{index + 1}</label>"
    div.append "<textarea id=\"gend_image_captions_attributes_#{index}_text\"
      name=\"gend_image[captions_attributes][#{index}][text]\"
      class=\"form-control\" cols=\"40\" rows=\"2\" /></textarea>"
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

$(document).ready ->
  text_add_init()
