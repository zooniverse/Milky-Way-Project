Controller = require 'zooniverse/controllers/base-controller'
Overlay = require './overlay'
translate = require 't7e'
MarkingSurface = require 'marking-surface'
Throbber = require './throbber'
$ = window.jQuery
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'
Footer = require 'zooniverse/controllers/footer'

tools =
  EllipseTool: require './tools/ellipse'
  CircleTool: require './tools/circle'
  ObjectTool: require './tools/object'

SUBJECT_WIDTH = 800
SUBJECT_HEIGHT = 400

loadImage = (src, callback) ->
  img = new Image
  img.onload = -> callback img
  img.src = src
  null

animate = (duration, step) ->
  deferred = new $.Deferred
  $(document.createElement 'span').animate {opacity: 0},
    duration: duration
    progress: (promise, step) -> deferred.notify step
    done: -> deferred.resolve()
  deferred.progress step if step?
  deferred.promise()

class Classify extends Controller
  className: "#{@::className} classify"
  template: require '../views/classify'

  events:
    'click button[name="favorite"]': 'onClickFavorite'
    'click button[name="help"]': 'onClickHelp'
    'change input[name="tool"]': 'onChangeTool'
    'click button[name="finish"]': 'onClickFinish'

  elements:
    '.discuss': 'talkLink'
    'button[name="favorite"]': 'favoriteButton'
    'button[name="help"]': 'helpButton'
    '.subject': 'subjectContainer'

  constructor: ->
    super

    window.classifer = @

    @helpOverlay = new Overlay
      className: 'classify-help'
      from: 'left'
      content: translate 'div', 'classify.help'
      associated: @helpButton

    @surface = new MarkingSurface
      tool: tools.EllipseTool
      width: SUBJECT_WIDTH
      height: SUBJECT_HEIGHT

    @subjectImage = @surface.addShape 'image'

    @subjectContainer.append @surface.el

    @throbber = new Throbber
      width: SUBJECT_WIDTH
      height: SUBJECT_HEIGHT / 2

    @subjectContainer.append @throbber.canvas

    User.on 'change', @onUserChange
    Subject.on 'get-next', @onSubjectGettingNext
    Subject.on 'select', @onSubjectSelect

  onClickFavorite: ->
    @classification.favorite = !@classification.favorite
    @favoriteButton.toggleClass 'active', @classification.favorite

  onClickHelp: ->
    @helpOverlay.toggle()

  onChangeTool: (e) ->
    @surface.tool = tools[e.currentTarget.value]

  onUserChange: (e, user) =>
    @el.toggleClass 'signed-in', user?
    Subject.next() if not @classification?

  onSubjectGettingNext: =>
    @talkLink.attr 'href', null
    @favoriteButton.attr 'disabled', true
    @throbber.start()
    $(@throbber.canvas).fadeIn()

  onSubjectSelect: (e, subject) =>
    console?.log 'Subject', subject.location.standard
    @surface.marks[0].destroy() until @surface.marks.length==0

    @classification?.destroy()
    @classification = new Classification {subject}

    @talkLink.attr 'href', subject.talkHref()

    @favoriteButton.toggleClass 'active', !!@classification.favorite
    @favoriteButton.attr 'disabled', false

    loadImage subject.location.standard, ({width, height}) =>
      slideOut = animate 500, (step) =>
        @subjectImage.attr
          opacity: 1 - step
          y: -1 * @surface.height * step

      slideOut.then =>
        @subjectImage.attr
          'xlink:href': subject.location.standard
          width: SUBJECT_WIDTH
          height: SUBJECT_HEIGHT

        slideIn = animate 500, (step) =>
          @subjectImage.attr
            opacity: step
            y: @surface.height + (-1 * @surface.height * step)

        slideIn.then =>
          $(@throbber.canvas).fadeOut 'slow', =>
            @throbber.stop()

  onClickFinish: ->
    @classification.annotate mark for mark in @surface.marks
    console?.log JSON.stringify @classification
    # @classification.send()

    Subject.next()

module.exports = Classify
