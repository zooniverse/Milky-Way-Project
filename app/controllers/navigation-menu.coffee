Controller = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class NavigationMenu extends Controller
  defaultHash: '#/'

  className: 'navigation-menu'
  template: require '../views/navigation-menu'

  hidden: true

  constructor: ->
    super

    @hide() if @hidden

    addEventListener 'hashchange', @onHashChange
    @onHashChange()

  onHashChange: =>
    currentHash = location.hash || @defaultHash
    for a in @el.find 'a'
      $(a).toggleClass 'active', a.hash is currentHash

  show: ->
    @el.toggleClass 'hidden', false
    @hidden = false

  hide: ->
    @el.toggleClass 'hidden', true
    @hidden = true

  toggle: ->
    if @hidden then @show() else @hide()

module.exports = NavigationMenu
