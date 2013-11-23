Controller = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

ESC = 27

class Overlay extends Controller
  content: ''
  associated: null

  className: 'overlay'
  template: require '../views/overlay'

  hidden: true

  constructor: ->
    super
    @associated = $(@associated)

    @hide() if @hidden
    @el.prependTo document.body

  onKeyDown: (e) =>
    if e.which is ESC
      @hide()

  toggle: ->
    if @hidden then @show() else @hide()

  show: ->
    @el.toggleClass 'hidden', false
    $(@associated)?.toggleClass 'showing-overlay', true
    @hidden = false
    addEventListener 'keydown', @onKeyDown, false

  hide: ->
    @el.toggleClass 'hidden', true
    $(@associated)?.toggleClass 'showing-overlay', false
    @hidden = true
    removeEventListener 'keydown', @onKeyDown, false

module.exports = Overlay
