Controller = require 'zooniverse/controllers/base-controller'
Footer = require 'zooniverse/controllers/footer'

class Home extends Controller
  template: require '../views/home'

  constructor: ->
    super
    @footer = new Footer
    @footer.el.appendTo @el

module.exports = Home
