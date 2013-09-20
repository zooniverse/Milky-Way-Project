$=window.jQuery
RectangleTool = require 'marking-surface/lib/tools/rectangle'
{ToolControls} = window?.MarkingSurface || require 'marking-surface'

class ObjectControls extends ToolControls
  constructor: ->
    super

    @el.innerHTML = require('../views/object-types')()
    $(@el).on('change', 'input[name="object-type"]', @onChangeRadioButtons)

  onChangeRadioButtons: (e) =>
    setTimeout =>
      @tool.mark.set 'content', $(@el).find("input[name='object-type']:checked").val()

  onToolSelect: ->
    super
    @el.style.display=''

  onToolDeselect: ->
    super
    @el.style.display='none'

class ObjectTool extends RectangleTool
  @Controls: ObjectControls

  initialize: ->
    super
    @mark.set 'content', ''

  # positionControls: ->
  #   @controls.moveTo @mark.left,  @mark.top + @mark.height, true

window?.MarkingSurface.ObjectTool = ObjectTool
module?.exports = ObjectTool