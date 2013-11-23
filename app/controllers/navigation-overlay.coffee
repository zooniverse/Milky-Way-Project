Overlay = require './overlay'
$ = window.jQuery

class NavigationMenu extends Overlay
  defaultHash: '#/'

  className: "#{Overlay::className} navigation-overlay"
  content: require('../views/navigation-overlay')()

  clickedVeryRecently: false

  constructor: ->
    super

    addEventListener 'hashchange', @onHashChange
    @onHashChange()

  events:
    click: ->
      @clickedVeryRecently = true
      setTimeout (=> @clickedVeryRecently = false), 50

  onHashChange: =>
    currentHash = location.hash || @defaultHash
    for a in @el.find 'a'
      $(a).toggleClass 'active', a.hash is currentHash

    if @clickedVeryRecently
      setTimeout (=> @hide()), 250

module.exports = NavigationMenu
