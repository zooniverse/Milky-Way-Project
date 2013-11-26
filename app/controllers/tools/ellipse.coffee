OriginalEllipseTool = require 'marking-surface/lib/tools/ellipse'

{PI, max, min, sqrt, pow, sin, cos} = Math

toRad = (t) -> t * (PI / 180)

class EllipseTool extends OriginalEllipseTool
  controlsOffset: 25
  controlsAngle: 45

  getControlsPosition: ->
    {rx: a, ry: b} = @mark
    theta = toRad @mark.angle + @controlsAngle

    r = (a * b) / sqrt(pow(b * cos(theta), 2) + pow(a * sin(theta), 2))

    # I don't actually know why this works.

    [
      @mark.center[0] + @controlsOffset + (r * sin toRad @controlsAngle)
      @mark.center[1] - @controlsOffset - (r * cos toRad @controlsAngle)
    ]

module.exports = EllipseTool
