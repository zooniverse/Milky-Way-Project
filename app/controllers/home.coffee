Controller = require 'zooniverse/controllers/base-controller'

class Home extends Controller
  className: 'home-page'
  template: require '../views/home'

  elements:
    '.why': 'whySection'

  constructor: ->
    super

module.exports = Home
