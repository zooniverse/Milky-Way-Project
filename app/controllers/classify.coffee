Controller = require 'zooniverse/controllers/base-controller'
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

loadImage = (src, callback) ->
  img = new Image
  img.onload = -> callback img.width, img.height
  img.src = src
  null

animation = (duration = 500) ->
  deferred = new $.Deferred
  $('<span></span>').animate {opacity: 0},
    duration: duration
    progress: (promise, step) -> deferred.notify step
    done: -> deferred.resolve()
  deferred.promise()

class Classify extends Controller
  className: "#{@::className} classify"
  template: require '../views/classify'

  events:
    'change input[name="tool"]': 'onChangeTool'
    'click button[name="finish"]': 'onClickFinish'
    'click button[name="next"]': 'onClickNext'

  elements:
    '.subject': 'subjectContainer'
    '.show-during': 'showDuring'
    '.show-after': 'showAfter'

  constructor: ->
    super

    window.classifer = @

    @surface = new MarkingSurface
      tool: EllipseTool
      width: 800
      height: 400

    @subjectImage = @surface.addShape 'image'

    @subjectContainer.append @surface.el

    # @footer = new Footer
    # @footer.el.appendTo @el

    User.on 'change', @onUserChange
    Subject.on 'getNext', @onSubjectGettingNext
    Subject.on 'select', @onSubjectSelect

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

    @classification = new Classification {subject}

    loadImage subject.location.standard, (width, height) =>
      @surface.resize width, height

      slideOut = animation()

      slideOut.progress (step) =>
        @subjectImage.attr 'y', -1 * @surface.height * step

      slideOut.then =>
        @subjectImage.attr {'xlink:href': subject.location.standard, width, height}

        slideIn = animation()

        slideIn.progress (step) =>
          @subjectImage.attr 'y', @surface.height + (-1 * @surface.height * step)

        slideIn.then =>
          @showDuring.show()
          @showAfter.hide()

  onClickFinish: ->
    @showDuring.hide()
    @showAfter.show()

    @classification.annotate mark for mark in @surface.marks
    console?.log JSON.stringify @classification

  onClickNext: ->
    Subject.next()

module.exports = Classify
