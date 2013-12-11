OriginalRectangleTool = require 'marking-surface/lib/tools/rectangle'

PROBABLY_IOS = require '../../lib/probably-ios'

class RectangleTool extends OriginalRectangleTool
  controlsOffset: 10

  handleSize: if PROBABLY_IOS then 20 else 7

  stroke: 'currentColor'
  handleStyle:
    fill: 'white'
    stroke: 'rgba(255, 255, 255, 0.01)'
    strokeWidth: 10

  initialize: ->
    super

    for handle in @handles
      handle.attr @handleStyle

  getControlsPosition: ->
    [@mark.left + @mark.width + @controlsOffset,  @mark.top - @controlsOffset]

module.exports = RectangleTool
