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
