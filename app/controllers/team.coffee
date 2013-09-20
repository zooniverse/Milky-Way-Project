Controller = require 'zooniverse/controllers/base-controller'
Footer = require 'zooniverse/controllers/footer'

class Team extends Controller
  template: require '../views/team'

  constructor: ->
    super
    @footer = new Footer
    @footer.el.appendTo @el

module.exports = Team
