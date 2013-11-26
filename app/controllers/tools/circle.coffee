EllipseTool = require 'marking-surface/lib/tools/ellipse'
MarkingSurface = require 'marking-surface'

class CircleTool extends EllipseTool
  defaultSquash: 1.0

  initialize: ->
    super
    @yHandle.attr "r", 0

  render: ->
    super
    @path.attr 'd', "M 0 0 L #{@mark.rx} 0"

  'on *drag xHandle': (e) =>
    {x, y} = @pointerOffset e
    h=@getHypotenuse @mark.center[0], @mark.center[1], x, y
    @mark.set
      angle: @getAngle @mark.center[0], @mark.center[1], x, y
      rx: h
      ry: h

MarkingSurface.CircleTool = CircleTool

module?.exports = CircleTool