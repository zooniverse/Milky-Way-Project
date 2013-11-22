BaseController = require 'zooniverse/controllers/base-controller'
NavigationButton = require './navigation-button'

class SiteHeader extends BaseController
  className: 'site-header'
  template: require '../views/site-header'

  constructor: ->
    super
    @navigationButton = new NavigationButton
    @navigationButton.el.appendTo @el.find '.navigation-container'

module.exports = SiteHeader
