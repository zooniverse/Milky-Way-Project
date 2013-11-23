Controller = require 'zooniverse/controllers/base-controller'
NavigationMenu = require './navigation-menu'

class NavigationButton extends Controller
  className: 'navigation-button'
  template: require '../views/navigation-button'

  elements:
    'button': 'button'

  constructor: ->
    super

    @navigationMenu = new NavigationMenu
    @navigationMenu.el.appendTo document.body

  events:
    'click button[name="toggle-menu"]': ->
      @navigationMenu.toggle()

module.exports = NavigationButton
