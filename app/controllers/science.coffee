Controller = require 'zooniverse/controllers/base-controller'
Footer = require 'zooniverse/controllers/footer'

class Science extends Controller
  template: require '../views/science'

  constructor: ->
    super
    @footer = new Footer
    @footer.el.appendTo @el

module.exports = Science
