describe 'text positioner', ->
  describe 'TextPositioner', ->

  describe 'Target', ->
    describe '#bound_top', ->
      describe 'when the target is outside the canvas', ->
        it 'moves the target inside the canvas', ->
          object = target:
            setTop: ->
            getTop: ->
              9
            getHeight: ->
              20

          t = new Target(object)

          spyOn(object.target, 'setTop')

          t.bound_top()

          expect(object.target.setTop).toHaveBeenCalledWith(10)

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
              width: 100

          t = new Target(object)

          spyOn(object.target, 'setLeft')

          t.bound_right()

          expect(object.target.setLeft).toHaveBeenCalledWith(75)

      describe 'when the target is inside the canvas', ->
        it 'does not move the target back inside the canvas', ->
          object = target:
            setLeft: ->
            getLeft: ->
              75
            getWidth: ->
              50
            canvas:
              width: 100

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
              height: 50

          t = new Target(object)

          spyOn(object.target, 'setTop')

          t.bound_bottom()

          expect(object.target.setTop).toHaveBeenCalledWith(40)

      describe 'when the target is inside the canvas', ->
        it 'does not move the target back inside the canvas', ->
          object = target:
            setTop: ->
            getTop: ->
              70
            getHeight: ->
              20
            canvas:
              height: 80

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
              10
            getWidth: ->
              30

          t = new Target(object)

          spyOn(object.target, 'setLeft')

          t.bound_left()

          expect(object.target.setLeft).toHaveBeenCalledWith(15)

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
      it 'does not change the x scale if it is less than or equal to the maximum', ->
        object = target:
          canvas:
            width: 100
          scaleX: 9
          width: 10

        t = new Target(object)

        t.bound_scale_x()

        expect(object.target.scaleX).toEqual(9)

      it 'sets the x scale to the maximum if it is over the maximum', ->
        object =
          target:
            canvas:
              width: 100
            scaleX: 11
            width: 10

        t = new Target(object)

        t.bound_scale_x()

        expect(object.target.scaleX).toEqual(10)

    describe '#bound_scale_y', ->
      it 'does not change the y scale if it is less than or equal to the maximum', ->
        object = target:
          canvas:
            height: 200
          height: 20
          scaleY: 9

        t = new Target(object)

        t.bound_scale_y()

        expect(object.target.scaleY).toEqual(9)

      it 'sets the y scale to the maximum if it is over the maximum', ->
        object = target:
          canvas:
            height: 200
          height: 20
          scaleY: 11

        t = new Target(object)

        t.bound_scale_y()

        expect(object.target.scaleY).toEqual(10)

    describe '#left_pct', ->
      it 'calculates the left percentage', ->
        object = target:
          canvas:
            width: 150
          getLeft: ->
            100
          getWidth: ->
            50

        t = new Target(object)

        expect(t.left_pct()).toEqual(0.5)

    describe '#top_pct', ->
      it 'calculates the top percentage', ->
        object = target:
          canvas:
            height: 100
          getHeight: ->
            100
          getTop: ->
            90

        t = new Target(object)

        expect(t.top_pct()).toEqual(0.4)

    describe '#width_pct', ->
      it 'calculates the width percentage', ->
        object = target:
          canvas:
            width: 100
          getWidth: ->
            30

        t = new Target(object)

        expect(t.width_pct()).toEqual(0.3)

    describe '#height_pct', ->
      it 'calculates the height percentage', ->
        object = target:
          canvas:
            height: 200
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
