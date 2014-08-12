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

    target.before "<label for=\"gend_image_captions_attributes_#{index}_text\">Caption #{index + 1}</label>"
    target.before "<textarea id=\"gend_image_captions_attributes_#{index}_text\" name=\"gend_image[captions_attributes][#{index}][text]\" class=\"input-xxlarge\" cols=\"40\" rows=\"2\" /></textarea>"
    form.find("#gend_image_captions_attributes_#{index}_text").focus()
    target.before "<input id=\"gend_image_captions_attributes_#{index}_font\" name=\"gend_image[captions_attributes][#{index}][font]\" type=\"hidden\" value=\"\" />"
    target.before "<input id=\"gend_image_captions_attributes_#{index}_top_left_x_pct\" name=\"gend_image[captions_attributes][#{index}][top_left_x_pct]\" type=\"hidden\" value=\"0.05\" />"
    target.before "<input id=\"gend_image_captions_attributes_#{index}_top_left_y_pct\" name=\"gend_image[captions_attributes][#{index}][top_left_y_pct]\" type=\"hidden\" value =\"0.375\" />"
    target.before "<input id=\"gend_image_captions_attributes_#{index}_width_pct\" name=\"gend_image[captions_attributes][#{index}][width_pct]\" type=\"hidden\" value=\"0.9\" />"
    target.before "<input id=\"gend_image_captions_attributes_#{index}_height_pct\" name=\"gend_image[captions_attributes][#{index}][height_pct]\" type =\"hidden\" value=\"0.25\" />"

    window.add_text_positioner index

$(document).ready ->
  text_add_init()
