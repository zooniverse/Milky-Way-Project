Controller = require 'zooniverse/controllers/base-controller'
Footer = require 'zooniverse/controllers/footer'

class Data extends Controller
  template: require '../views/data'

  constructor: ->
    super
    @footer = new Footer
    @footer.el.appendTo @el

module.exports = Data
