EllipseTool = require './ellipse'
MarkingSurface = require 'marking-surface'

class CircleTool extends EllipseTool
  defaultSquash: 1

  initialize: ->
    super
    @yHandle.attr "r", 0

  'on *drag xHandle': (e) =>
    {x, y} = @pointerOffset e

    angle = @getAngle @mark.center[0], @mark.center[1], x, y
    radius = @getHypotenuse @mark.center[0], @mark.center[1], x, y

    @mark.set
      angle: angle
      rx: radius
      ry: radius

  render: ->
    super
    @path.attr 'd', "M 0 0 L #{@mark.rx} 0"

MarkingSurface.CircleTool = CircleTool
module.exports = CircleTool
