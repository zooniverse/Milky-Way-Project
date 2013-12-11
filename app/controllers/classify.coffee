Controller = require 'zooniverse/controllers/base-controller'
Overlay = require './overlay'
translate = require 't7e'
MarkingSurface = require 'marking-surface'
EllipseTool = require './tools/ellipse'
CircleTool = require './tools/circle'
ObjectTool = require './tools/object'
Throbber = require './throbber'
{Tutorial} = require 'zootorial'
$ = window.jQuery
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
loginDialog = require 'zooniverse/controllers/login-dialog'
selectTutorialSubject = require '../lib/select-tutorial-subject'
Classification = require 'zooniverse/models/classification'

tools =
  bubble: class extends EllipseTool then name: 'bubble'
  cluster: class extends CircleTool then name: 'cluster'
  ego: class extends CircleTool then name: 'ego'
  galaxy: class extends CircleTool then name: 'galaxy'
  object: ObjectTool

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
    'click button[name="sign-in"]': 'onClickSignIn'
    'click button[name="favorite"]': 'onClickFavorite'
    'click button[name="help"]': 'onClickHelp'
    'change input[name="tool"]': 'onChangeTool'
    'click button[name="finish"]': 'onClickFinish'

  elements:
    '.discuss': 'talkLink'
    'button[name="sign-in"]': 'signInButton'
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
      tool: tools.bubble
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

    @tutorial = new Tutorial
      parent: @el.get 0
      attachment: [0.5, 0.5, @el.get(0), 0.5, 0.5]
      steps: require '../lib/tutorial-steps'
      onEnd: -> @guide?.remove()
      classifier: @

    User.on 'change', @onUserChange
    Subject.on 'get-next', @onSubjectGettingNext
    Subject.on 'select', @onSubjectSelect

  activate: ->
    setTimeout (=> @tutorial.attach() if @tutorial._current?), 500

  onClickSignIn: ->
    loginDialog.show()

  onClickFavorite: ->
    @classification.favorite = !@classification.favorite
    @favoriteButton.toggleClass 'active', @classification.favorite

  onClickHelp: ->
    @helpOverlay.toggle()

  onChangeTool: (e) ->
    @surface.tool = tools[e.currentTarget.value]

  onUserChange: (e, user) =>
    @el.toggleClass 'signed-in', user?

    @signInButton.toggle not user?
    @favoriteButton.toggle user?

    if user?.project?.tutorial_done
      Subject.next() if @surface.marks.length is 0
    else
      selectTutorialSubject()

  onSubjectGettingNext: =>
    @talkLink.attr 'href', null
    @favoriteButton.attr 'disabled', true
    @throbber.start()
    $(@throbber.canvas).fadeIn 'fast'

  onSubjectSelect: (e, subject) =>
    @surface.marks[0].destroy() until @surface.marks.length is 0

    @classification?.destroy()
    @classification = new Classification {subject}

    @talkLink.attr 'href', subject.talkHref()

    @favoriteButton.toggleClass 'active', !!@classification.favorite
    @favoriteButton.attr 'disabled', false

    loadImage subject.location.standard, =>
      @discardImage.attr 'xlink:href', @subjectImage.attr 'xlink:href'
      @discardImage.attr 'opacity', 1
      @subjectImage.attr 'xlink:href', subject.location.standard

      if subject.tutorial
        @tutorial.start()
      else if @tutorial._current?
        @tutorial.end()

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
    # console?.log JSON.stringify @classification
    @classification.send()

    @finishButton.attr 'disabled', true
    Subject.next()

module.exports = Classify
