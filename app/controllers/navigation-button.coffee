Controller = require 'zooniverse/controllers/base-controller'
NavigationOverlay = require './navigation-overlay'

class NavigationButton extends Controller
  className: 'navigation-button'
  template: require '../views/navigation-button'

  elements:
    'button': 'button'

  constructor: ->
    super

    @navigationOverlay = new NavigationOverlay

  events:
    'click button[name="toggle-menu"]': ->
      @navigationOverlay.toggle()

module.exports = NavigationButton
