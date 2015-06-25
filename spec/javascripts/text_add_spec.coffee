describe 'text_add', ->
  beforeEach ->
    loadFixtures 'text_add.html'
    spyOn window, 'add_text_positioner'
    text_add_init()

  describe 'adding a text box to the form', ->

    describe 'when the form has inputs', ->
      beforeEach ->
        $('#text-add-has-inputs').click()

      it 'adds a new label', ->
        expect($('#new_gend_image')).toContainHtml('<label
          for="gend_image_captions_attributes_2_text">Caption 3<\/label>')

      it 'adds a new text input', ->
        expect($('#new_gend_image')).toContainHtml('<textarea
          id="gend_image_captions_attributes_2_text"
          name="gend_image[captions_attributes][2][text]"
          class="form-control" cols="40" rows="2" />')

      it 'focuses the new text input', ->
        expect($('#new_gend_image > div.form-group >
          #gend_image_captions_attributes_2_text')).toBeFocused()

      it 'adds a new font input', ->
        expect($('#new_gend_image')).toContainHtml('<input
          id="gend_image_captions_attributes_2_font"
          name="gend_image[captions_attributes][2][font]"
          type="hidden" value="" />')

      it 'adds a new top left x percentage', ->
        expect($('#new_gend_image')).toContainHtml('<input
          id="gend_image_captions_attributes_2_top_left_x_pct"
          name="gend_image[captions_attributes][2][top_left_x_pct]"
          type="hidden" value="0.05" />')

      it 'adds a new top left y percentage', ->
        expect($('#new_gend_image')).toContainHtml('<input
          id="gend_image_captions_attributes_2_top_left_y_pct"
          name="gend_image[captions_attributes][2][top_left_y_pct]"
          type="hidden" value="0.375" />')

      it 'adds a new width percentage', ->
        expect($('#new_gend_image')).toContainHtml('<input
          id="gend_image_captions_attributes_2_width_pct"
          name="gend_image[captions_attributes][2][width_pct]"
          type="hidden" value="0.9" />')

      it 'adds a new height percentage', ->
        expect($('#new_gend_image')).toContainHtml('<input
          id="gend_image_captions_attributes_2_height_pct"
          name="gend_image[captions_attributes][2][height_pct]"
          type="hidden" value="0.25" />')

      it 'adds a new box to the text positioner', ->
        expect(window.add_text_positioner).toHaveBeenCalledWith 2

    describe 'when the form has no inputs', ->
      beforeEach ->
        $('#text-add-empty').click()

      it 'adds a new label', ->
        expect($('#empty')).toContainHtml('<label
          for="gend_image_captions_attributes_0_text">Caption 1<\/label>')

      it 'adds a new text input', ->
        expect($('#empty')).toContainHtml('<textarea
          id="gend_image_captions_attributes_0_text"
          name="gend_image[captions_attributes][0][text]"
          class="form-control" cols="40" rows="2" />')

      it 'focuses the new text input', ->
        expect($('#empty > div.form-group >
          #gend_image_captions_attributes_0_text')).toBeFocused()

      it 'adds a new font input', ->
        expect($('#empty')).toContainHtml('<input
          id="gend_image_captions_attributes_0_font"
          name="gend_image[captions_attributes][0][font]"
          type="hidden" value="" />')

      it 'adds a new top left x percentage', ->
        expect($('#empty')).toContainHtml('<input
          id="gend_image_captions_attributes_0_top_left_x_pct"
          name="gend_image[captions_attributes][0][top_left_x_pct]"
          type="hidden" value="0.05" />')

      it 'adds a new top left y percentage', ->
        expect($('#empty')).toContainHtml('<input
          id="gend_image_captions_attributes_0_top_left_y_pct"
          name="gend_image[captions_attributes][0][top_left_y_pct]"
          type="hidden" value="0.375" />')

      it 'adds a new width percentage', ->
        expect($('#empty')).toContainHtml('<input
          id="gend_image_captions_attributes_0_width_pct"
          name="gend_image[captions_attributes][0][width_pct]"
          type="hidden" value="0.9" />')

      it 'adds a new height percentage', ->
        expect($('#empty')).toContainHtml('<input
          id="gend_image_captions_attributes_0_height_pct"
          name="gend_image[captions_attributes][0][height_pct]"
          type="hidden" value="0.25" />')

      it 'adds a new box to the text positioner', ->
        expect(window.add_text_positioner).toHaveBeenCalledWith 0
