OriginalRectangleTool = require 'marking-surface/lib/tools/rectangle'

class RectangleTool extends OriginalRectangleTool
  controlsOffset: 10

  getControlsPosition: ->
    [@mark.left + @mark.width + @controlsOffset,  @mark.top - @controlsOffset]

module.exports = RectangleTool
