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
    'button[name="finish"]': 'finishButton'

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

    @surface.on 'change', =>
      @finishButton.toggleClass 'has-marks', @surface.marks.length > 0

    @subjectImage = @surface.addShape 'image',
      width: SUBJECT_WIDTH
      height: SUBJECT_HEIGHT

    @discardImage = @surface.addShape 'image',
      width: SUBJECT_WIDTH
      height: SUBJECT_HEIGHT

    @subjectContainer.append @surface.el

    @throbber = new Throbber
      width: SUBJECT_WIDTH
      height: SUBJECT_HEIGHT

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
    $(@throbber.canvas).fadeIn 'fast'

  onSubjectSelect: (e, subject) =>
    console?.log 'Subject', subject.location.standard
    @surface.marks[0].destroy() until @surface.marks.length==0

    @classification?.destroy()
    @classification = new Classification {subject}

    @talkLink.attr 'href', subject.talkHref()

    @favoriteButton.toggleClass 'active', !!@classification.favorite
    @favoriteButton.attr 'disabled', false

    loadImage subject.location.standard, =>
      @discardImage.attr 'xlink:href', @subjectImage.attr 'xlink:href'
      @discardImage.attr 'opacity', 1
      @subjectImage.attr 'xlink:href', subject.location.standard

      fade = animate 1000, (step) =>
        scale = 1 + (step / 2)
        @discardImage.attr
          opacity: 1 - step
          x: (SUBJECT_WIDTH - (SUBJECT_WIDTH / scale)) / -2
          y: (SUBJECT_HEIGHT - (SUBJECT_HEIGHT / scale)) / -2
          transform: "scale(#{scale}, #{scale})"

      fade.then =>
        $(@throbber.canvas).fadeOut 'slow', =>
          @throbber.stop()
          setTimeout (=> @finishButton.attr 'disabled', false), 1000

  onClickFinish: ->
    @classification.annotate mark for mark in @surface.marks
    console?.log JSON.stringify @classification
    # @classification.send()

    @finishButton.attr 'disabled', true
    Subject.next()

module.exports = Classify
