DefaultControls = require 'marking-surface/lib/tools/default-controls'
RectangleTool = require './rectangle'
$ = window.jQuery
MarkingSurface = require 'marking-surface'

class ObjectControls extends DefaultControls
  constructor: ->
    super

    $(@el).append require('../../views/object-types')()
    $(@el).on 'change', 'input[name="object-type"]', @onChangeRadioButtons

  onChangeRadioButtons: (e) =>
    setTimeout =>
      @tool.mark.set 'content', $(@el).find('input[name="object-type"]:checked').val()

class ObjectTool extends RectangleTool
  @Controls: ObjectControls

  initialize: ->
    super
    @mark.set 'content', ''

MarkingSurface.ObjectTool = ObjectTool
module.exports = ObjectTool
