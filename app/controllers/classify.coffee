Controller = require 'zooniverse/controllers/base-controller'
MarkingSurface = require 'marking-surface'
EllipseTool = require 'marking-surface/lib/tools/ellipse'
RectangleTool = require 'marking-surface/lib/tools/rectangle'

class Classify extends Controller
  className: "#{@::className} classify"
  template: require '../views/classify'

  events:
    'change input[name="tool"]': 'onChangeTool'

  elements:
    '.subject': 'subjectContainer'

  constructor: ->
    super

    @surface = new MarkingSurface
      tool: EllipseTool
      width: 600
      height: 400

    @subjectContainer.append @surface.el

  onChangeTool: (e) ->
    @surface.tool = MarkingSurface[e.currentTarget.value]

module.exports = Classify
