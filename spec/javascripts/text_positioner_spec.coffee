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

    describe '#bound_scale_y', ->

    describe '#left_pct', ->

    describe '#top_pct', ->

    describe '#width_pct', ->

    describe '#height_pct', ->

    describe '#fire', ->
