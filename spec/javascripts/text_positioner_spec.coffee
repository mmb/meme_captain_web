describe 'text positioner', ->
  describe 'TextPositioner', ->
    beforeEach ->
      loadFixtures 'text_positioner.html'
      window.text_positioner_init()

    it 'sets the initial canvas size to the image size', ->
      text_positioner = $('#tp1').data('tp')
      fabric_canvas = text_positioner.fabric_canvas

      expect(fabric_canvas.getWidth()).toEqual(200)
      expect(fabric_canvas.getHeight()).toEqual(100)

    it 'resizes when the div changes size', ->
      div = $('#tp1')
      div.width(150)
      text_positioner = div.data('tp')
      text_positioner.set_fabric_canvas_size()

      fabric_canvas = text_positioner.fabric_canvas

      expect(fabric_canvas.getWidth()).toEqual(150)
      expect(fabric_canvas.getHeight()).toEqual(75)

      rect1 = fabric_canvas.getObjects()[0]
      expect(rect1.getLeft()).toEqual(7.5)
      expect(rect1.getTop()).toEqual(0)
      expect(rect1.scaleX).toEqual(0.75)
      expect(rect1.scaleY).toEqual(0.75)

      rect2 = fabric_canvas.getObjects()[1]
      expect(rect2.getLeft()).toEqual(7.5)
      expect(rect2.getTop()).toEqual(56.25)
      expect(rect2.scaleX).toEqual(0.75)
      expect(rect2.scaleY).toEqual(0.75)

    it 'does not resize when the div is larger than the image', ->
      div = $('#tp1')
      div.width(400)
      text_positioner = div.data('tp')
      text_positioner.set_fabric_canvas_size()

      fabric_canvas = text_positioner.fabric_canvas

      expect(fabric_canvas.getWidth()).toEqual(200)
      expect(fabric_canvas.getHeight()).toEqual(100)

  describe 'Target', ->
    describe '#bound_top', ->
      describe 'when the target is outside the canvas', ->
        it 'moves the target inside the canvas', ->
          object = target:
            setTop: ->
            getTop: ->
              -1
            getHeight: ->
              20

          t = new Target(object)

          spyOn(object.target, 'setTop')

          t.bound_top()

          expect(object.target.setTop).toHaveBeenCalledWith(0)

      describe 'when the target is inside the canvas', ->
        it 'does not move the target back inside the canvas', ->
          object = target:
            setTop: ->
            getTop: ->
              10
            getHeight: ->
              20

          t = new Target(object)

          spyOn(object.target, 'setTop')

          t.bound_top()

          expect(object.target.setTop).not.toHaveBeenCalled()

    describe '#bound_right', ->
      describe 'when the target is outside the canvas', ->
        it 'moves the target inside the canvas', ->
          object = target:
            setLeft: ->
            getLeft: ->
              80
            getWidth: ->
              50
            canvas:
              getWidth: ->
                100

          t = new Target(object)

          spyOn(object.target, 'setLeft')

          t.bound_right()

          expect(object.target.setLeft).toHaveBeenCalledWith(50)

      describe 'when the target is inside the canvas', ->
        it 'does not move the target back inside the canvas', ->
          object = target:
            setLeft: ->
            getLeft: ->
              50
            getWidth: ->
              50
            canvas:
              getWidth: ->
                100

          t = new Target(object)

          spyOn(object.target, 'setLeft')

          t.bound_right()

          expect(object.target.setLeft).not.toHaveBeenCalled()

    describe '#bound_bottom', ->
      describe 'when the target is outside the canvas', ->
        it 'moves the target inside the canvas', ->
          object = target:
            setTop: ->
            getTop: ->
              45
            getHeight: ->
              20
            canvas:
              getHeight: ->
                50

          t = new Target(object)

          spyOn(object.target, 'setTop')

          t.bound_bottom()

          expect(object.target.setTop).toHaveBeenCalledWith(30)

      describe 'when the target is inside the canvas', ->
        it 'does not move the target back inside the canvas', ->
          object = target:
            setTop: ->
            getTop: ->
              70
            getHeight: ->
              20
            canvas:
              getHeight: ->
                80

          t = new Target(object)

          spyOn(object.target, 'setTop')

          t.bound_top()

          expect(object.target.setTop).not.toHaveBeenCalled()

    describe '#bound_left', ->
      describe 'when the target is outside the canvas', ->
        it 'moves the target inside the canvas', ->
          object = target:
            setLeft: ->
            getLeft: ->
              -5
            getWidth: ->
              30

          t = new Target(object)

          spyOn(object.target, 'setLeft')

          t.bound_left()

          expect(object.target.setLeft).toHaveBeenCalledWith(0)

      describe 'when the target is inside the canvas', ->
        it 'does not move the target back inside the canvas', ->
          object = target:
            setLeft: ->
            getLeft: ->
              10
            getWidth: ->
              20

          t = new Target(object)

          spyOn(object.target, 'setLeft')

          t.bound_left()

          expect(object.target.setLeft).not.toHaveBeenCalled()

    describe '#bound_scale_x', ->
      it 'does not change the x scale if the target is within the canvas', ->
        object = target:
          canvas:
            getWidth: ->
              100
          getLeft: ->
            10
          getWidth: ->
            10
          setScaleX: ->

        t = new Target(object)

        spyOn(object.target, 'setScaleX')

        t.bound_scale_x()

        expect(object.target.setScaleX).not.toHaveBeenCalled()

      it 'changes the x scale if the target is outside the canvas on the right', ->
        object =
          target:
            canvas:
              getWidth: ->
                100
            getLeft: ->
              95
            getWidth: ->
              10
            getScaleX: ->
              2
            setScaleX: ->

        t = new Target(object)

        spyOn(object.target, 'setScaleX')

        t.bound_scale_x()

        expect(object.target.setScaleX).toHaveBeenCalledWith(1)

      it 'changes the x scale if the target is outside the canvas on the left', ->
        object =
          target:
            canvas:
              getWidth: ->
                100
            getLeft: ->
              -5
            getWidth: ->
              10
            getScaleX: ->
              2
            setScaleX: ->
            setLeft: ->

        t = new Target(object)

        spyOn(object.target, 'setScaleX')
        spyOn(object.target, 'setLeft')

        t.bound_scale_x()

        expect(object.target.setScaleX).toHaveBeenCalledWith(1)
        expect(object.target.setLeft).toHaveBeenCalledWith(0)

    describe '#bound_scale_y', ->
      it 'does not change the y scale if the target is within the canvas', ->
        object = target:
          canvas:
            getHeight: ->
              200
          getTop: ->
            10
          getHeight: ->
            20
          setScaleY: ->

        t = new Target(object)

        spyOn(object.target, 'setScaleY')

        t.bound_scale_y()

        expect(object.target.setScaleY).not.toHaveBeenCalled()

      it 'changes the y scale if the target is outside the canvas on the bottom', ->
        object =
          target:
            canvas:
              getHeight: ->
                100
            getTop: ->
              95
            getHeight: ->
              10
            getScaleY: ->
              2
            setScaleY: ->

        t = new Target(object)

        spyOn(object.target, 'setScaleY')

        t.bound_scale_y()

        expect(object.target.setScaleY).toHaveBeenCalledWith(1)

      it 'changes the y scale if the target is outside the canvas on the top', ->
        object =
          target:
            canvas:
              getHeight: ->
                100
            getTop: ->
              -5
            getHeight: ->
              10
            getScaleY: ->
              2
            setScaleY: ->
            setTop: ->

        t = new Target(object)

        spyOn(object.target, 'setScaleY')
        spyOn(object.target, 'setTop')

        t.bound_scale_y()

        expect(object.target.setScaleY).toHaveBeenCalledWith(1)
        expect(object.target.setTop).toHaveBeenCalledWith(0)

    describe '#left_pct', ->
      it 'calculates the left percentage', ->
        object = target:
          canvas:
            getWidth: ->
              200
          getLeft: ->
            150

        t = new Target(object)

        expect(t.left_pct()).toEqual(0.75)

    describe '#top_pct', ->
      it 'calculates the top percentage', ->
        object = target:
          canvas:
            getHeight: ->
              100
          getTop: ->
            90

        t = new Target(object)

        expect(t.top_pct()).toEqual(0.9)

    describe '#width_pct', ->
      it 'calculates the width percentage', ->
        object = target:
          canvas:
            getWidth: ->
              100
          getWidth: ->
            30

        t = new Target(object)

        expect(t.width_pct()).toEqual(0.3)

    describe '#height_pct', ->
      it 'calculates the height percentage', ->
        object = target:
          canvas:
            getHeight: ->
              200
          getHeight: ->
            120

        t = new Target(object)

        expect(t.height_pct()).toEqual(0.6)

    describe '#fire', ->
      it 'fires the event', ->
        object = target:
          canvas:
            fire: ->

        t = new Target(object)

        spyOn(object.target.canvas, 'fire')

        t.fire 'event'

        expect(object.target.canvas.fire).toHaveBeenCalledWith('event', target: object.target)
