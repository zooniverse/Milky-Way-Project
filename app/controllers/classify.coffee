Controller = require 'zooniverse/controllers/base-controller'
Overlay = require './overlay'
MarkingSurface = require 'marking-surface'
EllipseTool = require 'marking-surface/lib/tools/ellipse'
DefaultControls = require 'marking-surface/lib/tools/default-controls'
CircleTool = require './circle-tool'
ObjectTool = require './object-tool'
$ = window.jQuery
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'
Footer = require 'zooniverse/controllers/footer'

EllipseTool.Controls = DefaultControls
CircleTool.Controls = DefaultControls

SUBJECT_WIDTH = 800
SUBJECT_HEIGHT = 400

loadImage = (src, callback) ->
  img = new Image
  img.onload = -> callback img
  img.src = src
  null

animate = ([duration]..., step) ->
  deferred = new $.Deferred
  $('<span></span>').animate {opacity: 0},
    duration: duration || 500
    progress: (promise, step) -> deferred.notify step
    done: -> deferred.resolve()
  deferred.progress step if step?
  deferred.promise()

class Classify extends Controller
  className: "#{@::className} classify"
  template: require '../views/classify'

  events:
    'click button[name="help"]': 'onClickHelp'
    'change input[name="tool"]': 'onChangeTool'
    'click button[name="finish"]': 'onClickFinish'

  elements:
    'button[name="help"]': 'helpButton'
    '.subject': 'subjectContainer'
    '.show-during': 'showDuring'
    '.show-after': 'showAfter'

  constructor: ->
    super

    window.classifer = @

    @helpOverlay = new Overlay
      from: 'left'
      content: '<p>TODO</p><p>Lorem ipsum dolor sit amet</p>'
      associated: @helpButton

    @surface = new MarkingSurface
      tool: EllipseTool
      width: SUBJECT_WIDTH
      height: SUBJECT_HEIGHT

    @subjectImage = @surface.addShape 'image'

    @subjectContainer.append @surface.el

    # @footer = new Footer
    # @footer.el.appendTo @el

    User.on 'change', @onUserChange
    Subject.on 'getNext', @onSubjectGettingNext
    Subject.on 'select', @onSubjectSelect

  onClickHelp: ->
    @helpOverlay.toggle()

  onChangeTool: (e) ->
    @surface.tool = MarkingSurface[e.currentTarget.value]

  onUserChange: (e, user) =>
    @el.toggleClass 'signed-in', user?
    Subject.next() if not @classification?

  onSubjectGettingNext: ->
    @el.addClass 'loading'

  onSubjectSelect: (e, subject) =>
    console?.log 'Subject', subject.location.standard
    @surface.marks[0].destroy() until @surface.marks.length==0

    @classification?.destroy()
    @classification = new Classification {subject}

    loadImage subject.location.standard, ({width, height}) =>
      slideOut = animate (step) =>
        @subjectImage.attr 'y', -1 * @surface.height * step

      slideOut.then =>
        @subjectImage.attr
          'xlink:href': subject.location.standard
          width: SUBJECT_WIDTH
          height: SUBJECT_HEIGHT

        slideIn = animate (step) =>
          @subjectImage.attr 'y', @surface.height + (-1 * @surface.height * step)

        slideIn.then =>
          @showDuring.show()
          @showAfter.hide()

  onClickFinish: ->
    @showDuring.hide()
    @showAfter.show()

    @classification.annotate mark for mark in @surface.marks
    console?.log JSON.stringify @classification
    # @classification.send()

    Subject.next()

module.exports = Classify
