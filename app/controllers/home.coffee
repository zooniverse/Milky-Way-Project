Controller = require 'zooniverse/controllers/base-controller'

class Home extends Controller
  className: 'home-page'
  template: require '../views/home'

module.exports = Home
