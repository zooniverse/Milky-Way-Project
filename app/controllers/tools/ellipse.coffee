OriginalEllipseTool = require 'marking-surface/lib/tools/ellipse'
DefaultControls = require 'marking-surface/lib/tools/default-controls'

{PI, max, min, sqrt, pow, sin, cos} = Math

PROBABLY_IOS = !!~navigator.userAgent.indexOf 'iO'

toRad = (t) -> t * (PI / 180)

class EllipseTool extends OriginalEllipseTool
  @Controls: DefaultControls

  name: ''

  handleRadius: if PROBABLY_IOS then 20 else 5

  controlsOffset: 15
  controlsAngle: 45

  handleStyle:
    fill: 'white'
    stroke: 'rgba(255, 255, 255, 0.01)'
    strokeWidth: 15

  initialize: ->
    super

    @mark.set 'name', @name

    @path.attr
      stroke: 'rgba(255, 255, 255, 0.25)'
      strokeWidth: 1
      strokeDasharray: []

    unless PROBABLY_IOS
      @xHandle.attr @handleStyle
      @yHandle.attr @handleStyle

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
