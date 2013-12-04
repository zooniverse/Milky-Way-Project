Overlay = require './overlay'
$ = window.jQuery

class NavigationMenu extends Overlay
  defaultHash: '#/'

  className: "#{Overlay::className} navigation-overlay"
  content: require('../views/navigation-overlay')()

  clickedVeryRecently: false

  constructor: ->
    super
    @onHashChangeForNav()
    addEventListener 'hashchange', @onHashChangeForNav, false

  onHashChangeForNav: =>
    currentHash = location.hash || @defaultHash
    for a in @el.find 'a'
      $(a).toggleClass 'active', a.hash is currentHash

module.exports = NavigationMenu
